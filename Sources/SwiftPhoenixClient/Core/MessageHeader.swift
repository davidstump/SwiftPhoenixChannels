//
//  MessageHeader.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/19/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation

//
//  MessageHeader.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/19/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation

struct MessageHeader: Decodable {
    
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
    let status: String?
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        joinRef = try? container.decode(String?.self)
        ref = try? container.decode(String?.self)
        topic = try container.decode(String.self)
        event = try container.decode(String.self)
        
        if event == ChannelEvent.reply {
            let wrapper = try container.decode(ReplyWrapper.self)
            status = wrapper.status
        } else {
            status = nil
        }
    }
}

public struct DecodedMessage {
    
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
    let status: String?
    
    /// If determined, then the data is the payload from the serializer.
    /// If undetermined, then the payload must be parsed from the data
    let payload: MessagePayload
}

public struct TypedMessage<T: Codable>: Codable {
    let joinRef: String?
    let ref: String?
    let topic: String
    let event: String
    public let status: String?
    public let payload: T
    
    init(
        message: DecodedMessage,
        payload: T
    ) {
        self.joinRef = message.joinRef
        self.ref = message.ref
        self.topic = message.topic
        self.event = message.event
        self.status = message.status
        self.payload = payload
    }
    
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        joinRef = try? container.decode(String?.self)
        ref = try? container.decode(String?.self)
        topic = try container.decode(String.self)
        event = try container.decode(String.self)
        
        if event == ChannelEvent.reply {
            let wrapper = try container.decode(TypedReplyWrapper<T>.self)
            status = wrapper.status
            payload = wrapper.payload
        } else {
            status = nil
            payload = try container.decode(T.self)
        }
    }
}

enum MessagePayload {
    case determined(Data)
    case undetermined(Data)
}


struct ReplyWrapper: Decodable {
    let status: String
}

struct TypedReplyWrapper<T: Codable>: Decodable {
    let status: String
    let payload: T
}

protocol BindingProtocol {
    func trigger(_ message: Message) throws
}

//struct RefBinding: BindingProtocol {
//
//    /// The event that the Binding is bound to
//    let event: String
//
//    /// The reference number of the Binding
//    let ref: Int
//
//    /// The callback to be triggered
//    let callback: MessageHandler
//
//    func trigger(_ message: Message) throws {
//        callback(message)
//    }
//}

struct TypedBindingProtocol<T: Codable>: BindingProtocol {
    
    /// The event that the Binding is bound to
    let event: String
    
    /// The reference number of the Binding
    let ref: Int
    
    /// The Type to decode to
    let type: T.Type
    
    /// The callback to be triggered
    let callback: (T) -> Void
    
    
    func trigger(_ message: Message) throws {
        let decodedPayload = try JSONDecoder().decode(type, from: message.payload)
        callback(decodedPayload)
    }
}

// IN CHannel
//
// let syncBindings: SynchronizedArray<BindingProtocol>
//
//func trigger(_ message: Message) {
//    let handledMessage = self.onMessage(message)
//
//    self.syncBindings.forEach {
//        do {
//            try $0.trigger(handledMessage)
//        } catch {
//            // TODO: Log error. It can't be thrown up the the User
//        }
//    }
//
//    self.syncBindingsDel.forEach { binding in
//        if binding.event == message.event {
//            binding.callback(handledMessage)
//        }
//    }
//}
//
//
