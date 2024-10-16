//
//  Payload.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 10/15/24.
//  Copyright © 2024 SwiftPhoenixClient. All rights reserved.
//

import Foundation

public typealias DictionaryPayload = [String: any Any & Sendable]


///
/// Provides a messages payload as either a string or as binary data.
///
public enum MessagePayload {
    
    case binary(Data)
    case json(String)
    case dictionary(DictionaryPayload)
    
    
    /// Force unwraps the enum as a binary. Throws if it was json
    public func asBinary() -> Data {
        switch self {
        case .binary(let data):
            data
        default:
            preconditionFailure("Expected payload to be data. Was json")
        }
    }
    
    /// Force unwraps the enum as json. Throws if it was binary
    public func asJson() -> String {
        switch self {
        case .json(let string):
            string
        default:
            preconditionFailure("Expected payload to be json. Was data")
        }
    }
}
