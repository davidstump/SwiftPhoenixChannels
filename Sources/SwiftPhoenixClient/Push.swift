// Copyright (c) 2021 David Stump <david@davidstump.net>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import Foundation

struct ReceiveHook {
    let status: String
    let callback: SubscriptionCallback
}

/// Represnts pushing data to a `Channel` through the `Socket`
public class Push {
    
    /// The channel sending the Push
    public weak var channel: Channel?
    
    /// The event, for example `phx_join`
    public let event: String
    
    /// The topic of the channel that is performing the Push
    public let topic: String
    
    /// The payload, for example ["user_id": "abc123"], expressed as Data
    public var payload: OutgoingPayload
    
    /// The push timeout. Default is 10.0 seconds
    public var timeout: TimeInterval
    
    /// The server's response to the Push
    var receivedMessage: IncomingMessage?
    
    /// Timer which triggers a timeout event
    var timeoutTimer: TimerQueue
    
    /// WorkItem to be performed when the timeout timer fires
    var timeoutWorkItem: DispatchWorkItem?
        
    /// Hooks into a Push. Where .receive("ok", callback(Payload)) are stored
    var receiveHooks: SynchronizedArray<ReceiveHook>
    
    /// True if the Push has been sent
    var sent: Bool
    
    /// The reference ID of the Push
    var ref: String?
    
    /// The event that is associated with the reference ID of the Push
    var refEvent: String?
    
    var decoder: PayloadDecoder {
        return self.channel?.socket?.decoder ?? PhoenixPayloadDecoder()
    }
    
    var encoder: PayloadEncoder {
        return self.channel?.socket?.encoder ?? PhoenixPayloadEncoder()
    }
    
    /// Initializes a Push
    ///
    /// - parameter channel: The Channel
    /// - parameter event: The event, for example ChannelEvent.join
    /// - parameter payload: Optional. The Payload to send, e.g. ["user_id": "abc123"]
    /// - parameter timeout: Optional. The push timeout. Default is 10.0s
    init(channel: Channel,
         event: String,
         payload: OutgoingPayload,
         timeout: TimeInterval
    ) {
        self.channel = channel
        self.event = event
        self.topic = channel.topic
        self.payload = payload
        self.timeout = timeout
        self.receivedMessage = nil
        self.timeoutTimer = TimerQueue.main
        self.receiveHooks = SynchronizedArray()
        self.sent = false
        self.ref = nil
    }
    
    
    
    /// Resets and sends the Push
    /// - parameter timeout: Optional. The push timeout. Default is 10.0s
    public func resend(_ timeout: TimeInterval = Defaults.timeoutInterval) {
        self.timeout = timeout
        self.reset()
        self.send()
    }
    
    /// Sends the Push. If it has already timed out, then the call will
    /// be ignored and return early. Use `resend` in this case.
    public func send() {
        guard !hasReceived(status: "timeout") else { return }
        
        self.startTimeout()
        self.sent = true
        
        let message = OutgoingMessage(
            joinRef: self.channel?.joinRef,
            ref: self.ref,
            topic: self.topic,
            event: self.event,
            payload: self.payload
        )
        
        self.channel?.socket?.push(outgoing: message)
    }
    
    /// Receive a specific event when sending an Outbound message. Subscribing
    /// to status events with this method does not guarantees no retain cycles.
    /// 
    /// Example:
    ///
    ///     channel
    ///         .send(event:"custom", payload: ["body": "example"])
    ///         .receive("error") { [weak self] payload in
    ///             print("Error: ", payload)
    ///         }
    ///
    /// - parameter status: Status to receive
    /// - parameter callback: Callback to fire when the status is recevied
    @discardableResult
    public func receive(_ status: String,
                        callback: @escaping (ChannelMessage<Data>) -> Void) -> Push {
        let subscriptionCallback = DataSubscriptionCallback(callback: callback)
        return _receive(status, callback: subscriptionCallback)
    }
    
    @discardableResult
    public func receiveJson(_ status: String,
                            callback: @escaping (ChannelMessage<Any>) -> Void) -> Push {
        let subscriptionCallback = JsonSubscriptionCallback(callback: callback)
        return _receive(status, callback: subscriptionCallback)
    }
    
    @discardableResult
    public func receiveDecodable<T: Codable>(_ status: String,
                                             of type: T.Type,
                                             callback: @escaping (ChannelMessage<T>) -> Void) -> Push {
        let subscriptionCallback = DecodableSubscriptionCallback(type: type, callback: callback)
        return _receive(status, callback: subscriptionCallback)
    }
    
    @discardableResult
    func internalReceive(_ status: String,
                         callback: @escaping (IncomingMessage) -> Void) -> Push {
        let subscriptionCallback = InternalSubscriptionCallback(callback: callback)
        return _receive(status, callback: subscriptionCallback)
    }
    
    func _receive(_ status: String, callback: SubscriptionCallback) -> Self {
        let hook = ReceiveHook(status: status, callback: callback)
        
        // If the message has already been received, pass it to the callback immediately
        if hasReceived(status: status), let receivedMessage = self.receivedMessage {
            hook.callback.trigger(receivedMessage)
        }
        
        self.receiveHooks.append(hook)
        
        return self
    }
    
    /// Resets the Push as it was after it was first tnitialized.
    internal func reset() {
        self.cancelRefEvent()
        self.ref = nil
        self.refEvent = nil
        self.receivedMessage = nil
        self.sent = false
    }
    
    
    /// Finds the receiveHook which needs to be informed of a status response
    ///
    /// - parameter status: Status which was received, e.g. "ok", "error", "timeout"
    /// - parameter response: Response that was received
    private func matchReceive(_ status: String, message: IncomingMessage) {
        self.receiveHooks.forEach { hook in
            if hook.status == status {
                hook.callback.trigger(message)
            }
        }
    }
    
    /// Reverses the result on channel.on(ChannelEvent, callback) that spawned the Push
    private func cancelRefEvent() {
        guard let refEvent = self.refEvent else { return }
        self.channel?.off(refEvent)
    }
    
    /// Cancel any ongoing Timeout Timer
    internal func cancelTimeout() {
        self.timeoutWorkItem?.cancel()
        self.timeoutWorkItem = nil
    }
    
    /// Starts the Timer which will trigger a timeout after a specific _timeout_
    /// time, in milliseconds, is reached.
    internal func startTimeout() {
        // Cancel any existing timeout before starting a new one
        if let safeWorkItem = timeoutWorkItem, !safeWorkItem.isCancelled {
            self.cancelTimeout()
        }
        
        guard
            let channel = channel,
            let socket = channel.socket else { return }
        
        let ref = socket.makeRef()
        let refEvent = channel.replyEventName(ref)
        
        self.ref = ref
        self.refEvent = refEvent
        
        /// If a response is received  before the Timer triggers, cancel timer
        /// and match the recevied event to it's corresponding hook
        channel.on(refEvent)._message { [weak self] incomingMessage in
            guard let self else { return }
            
            self.cancelRefEvent()
            self.cancelTimeout()
            self.receivedMessage = incomingMessage
            
            /// Check if there is event a status available
            guard let status = incomingMessage.status else { return }
            self.matchReceive(status, message: incomingMessage)
        }

        
        /// Setup and start the Timeout timer.
        let workItem = DispatchWorkItem {
            self.trigger("timeout", payload: [:])
        }
        
        self.timeoutWorkItem = workItem
        self.timeoutTimer.queue(timeInterval: timeout, execute: workItem)
    }
    
    /// Checks if a status has already been received by the Push.
    ///
    /// - parameter status: Status to check
    /// - return: True if given status has been received by the Push.
    internal func hasReceived(status: String) -> Bool {
        return self.receivedMessage?.status == status
    }
    
    /// Triggers an event to be sent though the Channel
    internal func trigger(_ status: String, payload: Payload) {
        /// If there is no ref event, then there is nothing to trigger on the channel
        guard let refEvent = self.refEvent else { return }
        
        self.channel?.trigger(
            event: refEvent,
            payload: payload,
            status: status
        )
    }
}
