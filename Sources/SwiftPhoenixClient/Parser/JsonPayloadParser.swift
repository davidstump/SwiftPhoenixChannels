//
//  JsonPayloadParser.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/27/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation


class JsonPayloadParser: PayloadParser {
    
    let payloadDecoder = PhoenixPayloadDecoder()
    let payloadEncoder = PhoenixPayloadEncoder()
    
    func parse(_ receivedMessage: ReceivedMessage) -> Result<Any, any Error> {
        Result {
            switch receivedMessage.payload {
            case .decided(let payloadData):
                return try payloadDecoder.decodeJsonObject(from: payloadData)
            case .deferred(let incomingMessageData):
                let array = try payloadDecoder.decodeJsonObject(from: incomingMessageData) as! [Any]
                let payloadJsonObject = array[4]
                
                if receivedMessage.event == ChannelEvent.reply {
                    guard
                        let payload = payloadJsonObject as? [String: Any],
                        let response = payload["response"]
                    else {
                        let text = String(data: incomingMessageData, encoding: .utf8) ?? "unparsable"
                        throw PhxError.serializerError(reason: .invalidReplyStructure(string: text))
                    }
                    return response
                    
                } else {
                    return payloadJsonObject
                }
            }
        }
    }
}
