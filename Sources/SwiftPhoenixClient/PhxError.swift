//
//  PhxError.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 10/28/24.
//  Copyright © 2024 SwiftPhoenixClient. All rights reserved.
//

import Foundation

public enum PhxError: Error {
    
    public enum SerializerReason {
        /// Couldn't decode the payload 
        case decodingPayloadFailed
        
        /// The string could not be converted to data
        case dataFromStringFailed(string: String)
        
        /// The string could not be creating from data
        case stringFromDataFailed(string: String)
        
        /// The received message could not be parsed as a channels message (i.e. "[join_ref, ref, topic, event, payload]")
        case invalidStructure(string: String)
        
        /// The received message was intended as a reply but failed validation
        case invalidReplyStructure(string: String)
        
        /// Attempted to decode a binary message but the KIND was unknown
        case invalidBinaryKind(string: String)
        
        /// Whle decoding, topic was missing
        case decodeMissingTopic
        
        /// Whle decoding, event was missing
        case decodeMissingEvent
    }
    
    case serializerError(reason: SerializerReason)
    
}
