//
//  IntermediateDeserializedMessage.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 9/13/24.
//  Copyright © 2024 SwiftPhoenixClient. All rights reserved.
//

import Foundation

/// Represents a Message received from the Server that has been decoded from the format
///     "[join_ref, ref, topic, event, payload]"
/// into a decodable structure. Will then further be converted into a `Message` before being
/// passed into the rest of the client
struct CodableServerMessage: Codable {
    let joinRef: String?
    let ref: String?
    let topic: String
    let event: String
    let payload: RawJsonValue
    
    init(
        joinRef: String?,
        ref: String?,
        topic: String,
        event: String,
        payload: RawJsonValue
    ) {
        self.joinRef = joinRef
        self.ref = ref
        self.topic = topic
        self.event = event
        self.payload = payload
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        joinRef = try? container.decode(String?.self)
        ref = try? container.decode(String?.self)
        topic = try container.decode(String.self)
        event = try container.decode(String.self)
        payload = try container.decode(RawJsonValue.self)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(joinRef)
        try container.encode(ref)
        try container.encode(topic)
        try container.encode(event)
        try container.encode(payload)
    }
}
