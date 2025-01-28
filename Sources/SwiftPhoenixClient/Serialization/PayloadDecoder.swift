//
//  PayloadDecoder.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 10/28/24.
//  Copyright © 2024 SwiftPhoenixClient. All rights reserved.
//

import Foundation

///
/// Decodes Payloads as either a Decodable or a generic `Any` JsonObject
///
public protocol PayloadDecoder {
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
    func decode(from data: Data) throws -> Any
    
}

public class PhoenixPayloadDecoder: PayloadDecoder {
    public func decode<T>(_ type: T.Type,
                                   from data: Data) throws -> T where T : Decodable {
        return try JSONDecoder().decode(type, from: data)
    }
    
    public func decode(from data: Data) throws -> Any {
        return try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
    }
}
