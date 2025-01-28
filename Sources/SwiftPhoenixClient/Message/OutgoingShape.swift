//
//  OutgoingShape.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/28/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation

/// Represents the final shape to be encoded into a string before being sent to the Server
internal struct OutgoingShape: Encodable {
    
    let joinRef: String?
    let ref: String?
    let topic: String
    let event: String
    let payload: Encodable

    init(message: OutgoingMessage, payload: Encodable) {
        self.joinRef = message.joinRef
        self.ref = message.ref
        self.topic = message.topic
        self.event = message.event
        self.payload = payload
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
