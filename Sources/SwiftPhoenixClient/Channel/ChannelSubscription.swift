//
//  ChannelSubscription.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/27/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation


protocol SubscriptionCallback {
    
    func trigger(_ decodedMessage: IncomingMessage,
                 payloadDecoder: PayloadDecoder,
                 payloadEncoder: PayloadEncoder)
    
}

struct InternalSubscriptionCallback: SubscriptionCallback {
    let callback: (IncomingMessage) -> Void
    
    func trigger(_ incomingMessage: IncomingMessage,
                 payloadDecoder: PayloadDecoder,
                 payloadEncoder: PayloadEncoder) {
        callback(incomingMessage)
    }
}


struct DataSubscriptionCallback: SubscriptionCallback {
    
    let parser = DataPayloadParser()
    let callback: (ChannelMessage<Data>) -> Void
    
    func trigger(_ incomingMessage: IncomingMessage,
                 payloadDecoder: PayloadDecoder,
                 payloadEncoder: PayloadEncoder) {
        let result = self.parser.parse(incomingMessage,
                                       payloadDecoder: payloadDecoder,
                                       payloadEncoder: payloadEncoder)
        let channelMessage = ChannelMessage(from: incomingMessage, payload: result)
        callback(channelMessage)
    }
}

struct JsonSubscriptionCallback: SubscriptionCallback {
    
    let parser = JsonPayloadParser()
    let callback: (ChannelMessage<Any>) -> Void
    
    func trigger(_ incomingMessage: IncomingMessage,
                 payloadDecoder: PayloadDecoder,
                 payloadEncoder: PayloadEncoder) {
        let result = self.parser.parse(incomingMessage,
                                       payloadDecoder: payloadDecoder,
                                       payloadEncoder: payloadEncoder)
        let channelMessage = ChannelMessage(from: incomingMessage, payload: result)
        callback(channelMessage)
    }
}

struct DecodableSubscriptionCallback<T: Decodable>: SubscriptionCallback {
    
    let parser: DecodablePayloadParser<T>
    let callback: (ChannelMessage<T>) -> Void
    
    init(
        type: T.Type,
        callback: @escaping (ChannelMessage<T>) -> Void) {
            self.parser = DecodablePayloadParser(type: type)
            self.callback = callback
        }
    
    
    func trigger(_ incomingMessage: IncomingMessage,
                 payloadDecoder: PayloadDecoder,
                 payloadEncoder: PayloadEncoder) {
        let result = self.parser.parse(incomingMessage,
                                       payloadDecoder: payloadDecoder,
                                       payloadEncoder: payloadEncoder)
        let channelMessage = ChannelMessage(from: incomingMessage, payload: result)
        callback(channelMessage)
    }
}

public struct ChannelMessage<PayloadType> {
    
    /// The unique string ref when joining
    let joinRef: String?
    
    /// The unique string ref
    let ref: String?
    
    /// The string topic or topic:subtopic pair namespace, for example
    /// "messages", "messages:123"
    let topic: String
    
    /// The string event name, for example "phx_join"
    let event: String
    
    /// The reply status as a string
    public let status: String?
    
    /// The payload of the message to send or that was received. Wrapped in a
    /// `Result` so that serialization errors can be passed up to the caller.
    public let payload: Result<PayloadType, Swift.Error>
    
    init(from message: IncomingMessage, payload: Result<PayloadType, Swift.Error>) {
        self.joinRef = message.joinRef
        self.ref = message.ref
        self.topic = message.topic
        self.event = message.event
        self.status = message.status
        self.payload = payload
    }
}

class ChannelSubscription {
    
    // The event to subscription is bound to
    let event: String
    
    // The subscriptions ref, used to cancel the subscription.
    let ref: Int
    
    let callback: SubscriptionCallback
    
    init(event: String, ref: Int, callback: SubscriptionCallback) {
        self.event = event
        self.ref = ref
        self.callback = callback
    }
    
    convenience init(event: String, ref: Int, callback: @escaping (ChannelMessage<Any>) -> Void) {
        self.init(event: event, ref: ref, callback: JsonSubscriptionCallback(callback: callback))
    }
    
    convenience init(event: String, ref: Int, callback: @escaping (ChannelMessage<Data>) -> Void) {
        self.init(event: event, ref: ref, callback: DataSubscriptionCallback(callback: callback))
    }
    
    convenience init<T: Decodable>(event: String,
                                   ref: Int,
                                   type: T.Type,
                                   callback: @escaping (ChannelMessage<T>) -> Void) {
        self.init(event: event,
                  ref: ref,
                  callback: DecodableSubscriptionCallback(type: type, callback: callback))
    }
    
    convenience init(event: String, ref: Int, callback: @escaping (IncomingMessage) -> Void) {
        self.init(event: event, ref: ref, callback: InternalSubscriptionCallback(callback: callback))
    }

    func trigger(_ incomingMessage: IncomingMessage,
                 payloadDecoder: PayloadDecoder,
                 payloadEncoder: PayloadEncoder) {
            self.callback.trigger(incomingMessage,
                                         payloadDecoder: payloadDecoder,
                                         payloadEncoder: payloadEncoder)
    }
}


