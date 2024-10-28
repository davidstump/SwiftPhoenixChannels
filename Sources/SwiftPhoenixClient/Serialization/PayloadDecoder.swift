//
//  PayloadDecoder.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 10/28/24.
//  Copyright © 2024 SwiftPhoenixClient. All rights reserved.
//

import Foundation

///
/// Provides methods for decoding an inbound mesage into a Decodable
/// or a [String: Any].
///
public protocol PayloadDecoder {
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
    
    func decode(_ data: Data) throws -> [String: Any]
    
}

public class PhoenixPayloadDecoder: PayloadDecoder {
    public func decode<T>(_ type: T.Type,
                          from data: Data) throws -> T where T : Decodable {
        return try JSONDecoder().decode(type, from: data)
    }
    
    public func decode(_ data: Data) throws -> [String : Any] {
        return try JSONSerialization.jsonObject(with: data) as! [String: Any]
    }
}
