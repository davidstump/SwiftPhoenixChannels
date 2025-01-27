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
    
    func parse(_ decodedMessage: DecodedMessage) -> Result<T, any Error> {
        Result {
            switch decodedMessage.payload {
            case .determined(let payloadData):
                let payload = try payloadDecoder.decode(type, from: payloadData)
                let typedMessage = TypedMessage(message: decodedMessage, payload: payload)
                
                return typedMessage.payload
            case .undetermined(let incomingMessageData):
                let typedMessage = try payloadDecoder.decode(TypedMessage<T>.self,
                                                             from: incomingMessageData)
                return typedMessage.payload
            }
        }
    }
}
