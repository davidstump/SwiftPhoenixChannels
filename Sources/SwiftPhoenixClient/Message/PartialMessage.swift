//
//  PartialMessage.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/27/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation

///
/// Allows us to decode all but the payload from incoming raw text messages
/// and defer decoding the payload until later.
/// 
struct PartialMessage: Decodable {
    
    let joinRef: String?
    let ref: String?
    let topic: String
    let event: String
    let status: String?
    
    init(from decoder: any Decoder) throws {
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
