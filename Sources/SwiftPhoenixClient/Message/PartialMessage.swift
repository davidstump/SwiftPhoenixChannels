//
//  PartialMessage.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/27/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation

struct PartialMessage: Decodable {
    
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
    

    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        joinRef = try? container.decode(String?.self)
        ref = try? container.decode(String?.self)
        topic = try container.decode(String.self)
        event = try container.decode(String.self)

        if event == ChannelEvent.reply {
            let wrapper = try container.decode(PartialReplyWrapper.self)
            status = wrapper.status
        } else {
            status = nil
        }
    }

}

struct PartialReplyWrapper: Decodable {
    let status: String
}
