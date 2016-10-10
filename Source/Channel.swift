//
//  Channel.swift
//  SwiftPhoenixClient
//

import Swift

public class Channel {
    var bindings: [Phoenix.Binding] = []
    var topic: String?
    var message: Phoenix.Message?
    var callback: ((Any) -> Void?)
    weak var socket: Socket?

    /**
     Initializes a new Channel mapping to a server-side channel
     - parameter topic:    String topic for given channel
     - parameter message:  Phoenix.Message object containing message to send
     - parameter callback: Function to pass along with the channel instance
     - parameter socket:   Socket for websocket connection
     - returns: Channel
     */
    init(topic: String, message: Phoenix.Message, callback: @escaping ((Any) -> Void), socket: Socket) {
        (self.topic, self.message, self.callback, self.socket) = (topic, message, { callback($0) }, socket)
        reset()
    }

    /**
     Removes existing bindings
     */
    func reset() {
        bindings = []
    }

    /**
     Assigns Binding events to the channel bindings array
     - parameter event:    String event name
     - parameter callback: Function to run on event
     */
    public func on(event: String, callback: @escaping ((Any) -> Void)) {
        bindings.append(Phoenix.Binding(event: event, callback: { callback($0) }))
    }

    /**
     Determine if a topic belongs in this channel
     - parameter topic: String topic name for comparison
     - returns: Boolean
     */
    func isMember(topic: String) -> Bool {
        return self.topic == topic
    }

    /**
     Removes an event binding from this cahnnel
     - parameter event: String event name
     */
    func off(event: String) {
        var newBindings: [Phoenix.Binding] = []
        for binding in bindings {
            if binding.event != event {
                newBindings.append(Phoenix.Binding(event: binding.event, callback: binding.callback))
            }
        }
        bindings = newBindings
    }

    /**
     Triggers an event on this channel
     - parameter triggerEvent: String event name
     - parameter msg:          Phoenix.Message to pass into event callback
     */
    func trigger(triggerEvent: String, msg: Phoenix.Message) {
        for binding in bindings {
            if binding.event == triggerEvent {
                binding.callback(msg)
            }
        }
    }

    /**
     Sends and event and message through the socket
     - parameter event:   String event name
     - parameter message: Phoenix.Message payload
     */
    func send(event: String, message: Phoenix.Message) {
        print("conn sending")
        let payload = Phoenix.Payload(topic: topic!, event: event, message: message)
        socket?.send(data: payload)
    }

    /**
     Leaves the socket
     - parameter message: Phoenix.Message to pass to the Socket#leave function
     */
    func leave(message: Phoenix.Message) {
        if let sock = socket {
            sock.leave(topic: topic!, message: message)
        }
        reset()
    }
}
