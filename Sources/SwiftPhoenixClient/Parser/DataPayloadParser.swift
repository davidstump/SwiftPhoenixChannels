//
//  DataPayloadParser.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/27/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation

class DataPayloadParser: PayloadParser {
    
    let payloadDecoder = PhoenixPayloadDecoder()
    let payloadEncoder = PhoenixPayloadEncoder()
    
    func parse(_ incomingMessage: IncomingMessage) -> Result<Data, any Error> {
        Result {
            switch incomingMessage.payload {
            case .decided(let payloadData):
                return payloadData
            case .deferred(let incomingMessageData):
                let array = try payloadDecoder.decode(from: incomingMessageData) as! [Any]
                let payloadJsonObject = array[4]
             
                if incomingMessage.event == ChannelEvent.reply {
                    guard
                        let payload = payloadJsonObject as? [String: Any],
                        let response = payload["response"]
                    else {
                        let text = String(data: incomingMessageData, encoding: .utf8) ?? "unparsable"
                        throw PhxError.serializerError(reason: .invalidReplyStructure(string: text))
                    }
                    
                    return try payloadEncoder.encode(any: response)
                } else {
                    return try payloadEncoder.encode(any: payloadJsonObject)
                }
            }
        }
    }
}
