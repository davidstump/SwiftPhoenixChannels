//
//  PayloadEncoder.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 10/19/24.
//  Copyright © 2024 SwiftPhoenixClient. All rights reserved.
//

import Foundation

///
/// Provides methods for encoding Encodable and [String: Any]
/// payloads into an outbound message.
///
public protocol PayloadEncoder {
    func encode(_ encodable: Encodable) throws -> Data
    
    func encode(_ dictionary: [String: Any]) throws -> Data
}


public class PhoenixPayloadEncoder: PayloadEncoder {
    public func encode(_ encodable: any Encodable) throws -> Data {
        return try JSONEncoder().encode(encodable)
    }
    
    public func encode(_ dictionary: [String : Any]) throws -> Data{
        return try JSONSerialization.data(withJSONObject: dictionary)
    }
}


///
/// Provides methods for decoding an inbound mesage into a Decodable
/// or a [String: Any].
public protocol PayloadDecoder {
    
    func decode(_ type: Decodable.Type, data: Data) throws -> Decodable
    
    func decode(_ data: Data) throws -> [String: Any]
    
}

public class PhoenixPayloadDecoder: PayloadDecoder {
    public func decode(_ type: any Decodable.Type,
                       data: Data) throws -> any Decodable {
        return try JSONDecoder().decode(type, from: data)
    }
    
    public func decode(_ data: Data) throws -> [String : Any] {
        return try JSONSerialization.jsonObject(with: data) as! [String: Any]
    }
}
