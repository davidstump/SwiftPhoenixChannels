//
//  DecodablePayloadParser.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/27/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation

///
/// `PayloadParser` that attempts to convert an `IncomingMessage`'s payload to
/// a `Decodable` object.
///
struct DecodablePayloadParser<T: Decodable>: PayloadParser {
    
    /// The Type to decode to
    let type: T.Type
    
    init(type: T.Type) {
        self.type = type
    }
    
    func parse(_ incomingMessage: IncomingMessage,
               payloadDecoder: PayloadDecoder,
               payloadEncoder: PayloadEncoder) -> Result<T, any Error> {
        Result {
            switch incomingMessage.payload {
            case .decided(let payloadData):
                return try payloadDecoder.decode(type, from: payloadData)
                
            case .deferred(let incomingMessageData):
                let decodablePayload = try payloadDecoder.decode(DecodablePayload<T>.self,
                                                                 from: incomingMessageData)
                return decodablePayload.payload
            }
        }
    }
}

/// An intermediate class to parse a `.deferred` payload into a Decodable
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
            payload = wrapper.response
        } else {
            payload = try container.decode(T.self)
        }
    }
}

struct DecodableReplyWrapper<T: Decodable>: Decodable {
    let response: T
}
