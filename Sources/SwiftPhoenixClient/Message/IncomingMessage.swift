//
//  IncomingMessage.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/27/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation

///
/// Defines a message dispatched from the Server and received by the client.
///
/// The serialized format from the server will be in the shape of
///
///     [join_ref,ref,topic,event,payload]
///
/// If the message was a reply from the server in response to a Push from the
/// client, then the serialized  message from the server will be in the shape of
///
///     [join_ref,ref,topic,nil,%{"status":status,"response":payload}]
///
/// In addition to the parsed values from the server, the original messages can also be
/// accessed for additional information.
public struct IncomingMessage {
    
    /// The unique string ref when joining
    public let joinRef: String?
    
    /// The unique string ref
    public let ref: String?
    
    /// The string topic or topic:subtopic pair namespace, for example
    /// "messages", "messages:123"
    public let topic: String
    
    /// The string event name, for example "phx_join"
    public internal(set) var event: String
    
    /// The reply status as a string
    public let status: String?
    
    /// If determined, then the data is the payload from the serializer.
    /// If undetermined, then the payload must be parsed from the data
    internal let payload: ReceivedPayload
    
    /// The raw text from the server if the message was sent as a String
    public let rawText: String?
    
    /// The raw binary value from the server if the message was sent as Data
    public let rawBinary: Data?
}

enum ReceivedPayload {
    /// The payload was fully accessible at the point of Serialization. The data
    /// excludes all other values, such as status, ref, topic, and only represents
    /// the payload from the Server.
    case decided(payload: Data)
    
    /// The payload was not fully decoded at the point of Serialization and must
    /// be full decoded at the point of being triggered to a Channel subscription.
    /// In this case, the data value is the _entire message_ received from the server,
    /// including the join_ref, ref,  topic, etc.
    case deferred(entireIncomingMessageData: Data)
}
