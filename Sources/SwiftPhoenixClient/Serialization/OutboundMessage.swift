//
//  OutboundMessage.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 10/28/24.
//  Copyright © 2024 SwiftPhoenixClient. All rights reserved.
//

///
/// Represents a `Message` that can be encoded to a String and pushed to the
/// Server with the format
///
///     "[join_ref, ref, topic, event, payload]"
///
struct OutboundMessage: Codable {
    let joinRef: String?
    let ref: String?
    let topic: String
    let event: String
    let payload: RawJsonValue
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(joinRef)
        try container.encode(ref)
        try container.encode(topic)
        try container.encode(event)
        try container.encode(payload)
    }
}
