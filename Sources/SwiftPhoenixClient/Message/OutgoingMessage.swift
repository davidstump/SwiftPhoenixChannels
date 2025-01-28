//
//  OutgoingMessage.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/27/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation

import Foundation

///
/// Defines a message that originates from the client and is being sent to the Server.
///
/// The message will be encoded into following shape before being sent
///
///     [join_ref,ref,topic,event,payload]
///
///
public struct OutgoingMessage {
        
    /// The unique string ref when joining
    public let joinRef: String?
    
    /// The unique string ref
    public let ref: String?
    
    /// The string topic or topic:subtopic pair namespace, for example
    /// "messages", "messages:123"
    public let topic: String
    
    /// The string event name, for example "phx_join"
    public let event: String
    
    /// The payload of the message to send or that was received.`
    public let payload: OutgoingPayload
}

public enum OutgoingPayload {
    case binary(Data)
    case codable(Codable)
    case json(Any)
}

