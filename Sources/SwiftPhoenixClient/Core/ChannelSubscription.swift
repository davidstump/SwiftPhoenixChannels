//
//  ChannelSubscription.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/27/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation


protocol SubscriptionCallback {
    
    func trigger(_ decodedMessage: DecodedMessage)
    
}

struct InternalSubscriptionCallback: SubscriptionCallback {
    let callback: (DecodedMessage) -> Void
    
    func trigger(_ decodedMessage: DecodedMessage) {
        callback(decodedMessage)
    }
}


struct DataSubscriptionCallback: SubscriptionCallback {
    
    let parser = DataPayloadParser()
    let callback: (ChannelMessage<Data>) -> Void
    
    func trigger(_ decodedMessage: DecodedMessage) {
        let result = self.parser.parse(decodedMessage)
        let channelMessage = ChannelMessage(from: decodedMessage, payload: result)
        callback(channelMessage)
    }
}

struct JsonSubscriptionCallback: SubscriptionCallback {
    
    let parser = JsonPayloadParser()
    let callback: (ChannelMessage<Any>) -> Void
    
    func trigger(_ decodedMessage: DecodedMessage) {
        let result = self.parser.parse(decodedMessage)
        let channelMessage = ChannelMessage(from: decodedMessage, payload: result)
        callback(channelMessage)
    }
}

struct DecodableSubscriptionCallback<T: Codable>: SubscriptionCallback {
    
    let parser: DecodablePayloadParser<T>
    let callback: (ChannelMessage<T>) -> Void
    
    init(
        type: T.Type,
        callback: @escaping (ChannelMessage<T>) -> Void) {
            self.parser = DecodablePayloadParser(type: type)
            self.callback = callback
        }
    
    
    func trigger(_ decodedMessage: DecodedMessage) {
        let result = self.parser.parse(decodedMessage)
        let channelMessage = ChannelMessage(from: decodedMessage, payload: result)
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
    
    init(from message: DecodedMessage, payload: Result<PayloadType, Swift.Error>) {
        self.joinRef = message.joinRef
        self.ref = message.ref
        self.topic = message.topic
        self.event = message.event
        self.status = message.status
        self.payload = payload
    }
    
}

public class ChannelSubscription {
    
    // The event to subscription is bound to
    let event: String
    
    // The subscriptions ref, used to cancel the subscription.
    let ref: Int
    
    let callbacks: SynchronizedArray<SubscriptionCallback>
    
    init(event: String, ref: Int) {
        self.event = event
        self.ref = ref
        self.callbacks = SynchronizedArray()
    }
    
    @discardableResult
    public func message(_ callback: @escaping (ChannelMessage<Data>) -> Void) -> Self {
        let callback = DataSubscriptionCallback(callback: callback)
        self.callbacks.append(callback)
        
        return self
    }
    
    @discardableResult
    public func messageJson(_ callback: @escaping (ChannelMessage<Any>) -> Void) -> Self {
        let callback = JsonSubscriptionCallback(callback: callback)
        self.callbacks.append(callback)
        
        return self
    }
    
    @discardableResult
    public func messageDecodable<T: Codable>(of type: T.Type,
                                             _ callback: @escaping (ChannelMessage<T>) -> Void) -> Self {
        let callback = DecodableSubscriptionCallback(type: type, callback: callback)
        self.callbacks.append(callback)
        
        return self
    }
    
    @discardableResult
    func _message(_ callback: @escaping (DecodedMessage) -> Void) -> Self {
        let callback = InternalSubscriptionCallback(callback: callback)
        self.callbacks.append(callback)
        
        return self
    }
    
    func trigger(_ decodedMessage: DecodedMessage) {
        self.callbacks.forEach { $0.trigger(decodedMessage) }
    }
}


