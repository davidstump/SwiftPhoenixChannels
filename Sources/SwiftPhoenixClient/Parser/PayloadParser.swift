//
//  PayloadParser.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/27/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation

///
/// Parses the payload of an `IncomingMessage` into the associated `PayloadType`
///
protocol PayloadParser<PayloadType> {
    associatedtype PayloadType
    
    func parse(_ incomingMessage: IncomingMessage) -> Result<PayloadType, any Error>
}
