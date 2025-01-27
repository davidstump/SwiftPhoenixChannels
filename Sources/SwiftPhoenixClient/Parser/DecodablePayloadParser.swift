//
//  DecodablePayloadParser.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/27/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation

struct DecodablePayloadParser<T: Codable>: PayloadParser {
    
    let payloadDecoder = PhoenixPayloadDecoder()

    /// The Type to decode to
    let type: T.Type
    
    func parse(_ receivedMessage: ReceivedMessage) -> Result<T, any Error> {
        Result {
            switch receivedMessage.payload {
            case .decided(let payloadData):
                return try payloadDecoder.decode(type, from: payloadData)
                
            case .deferred(let incomingMessageData):
                let typedMessage = try payloadDecoder.decode(DecodablePayload<T>.self,
                                                             from: incomingMessageData)
                return typedMessage.payload
            }
        }
    }
}

struct DecodablePayload<T: Decodable>: Decodable {

    let payload: T
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try? container.decode(String?.self) /*joinRef*/
        let _ = try? container.decode(String?.self) /*ref*/
        let _ = try container.decode(String.self) /*topic*/
        let event = try container.decode(String.self) /*event*/
        
        if event == ChannelEvent.reply {
            let wrapper = try container.decode(DecodableReplyWrapper<T>.self)
            payload = wrapper.payload
        } else {
            payload = try container.decode(T.self)
        }
    }
}

struct DecodableReplyWrapper<T: Decodable>: Decodable {
    let status: String
    let payload: T
}
