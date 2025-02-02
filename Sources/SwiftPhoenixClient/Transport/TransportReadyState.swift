//
//  TransportReadyState.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 2/2/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation

/// Available `ReadyState`s of a `Transport` layer.
public enum TransportReadyState {
    
    /// The `Transport` is opening a connection to the server.
    case connecting
    
    /// The `Transport` is connected to the server.
    case open
    
    /// The `Transport` is closing the connection to the server.
    case closing
    
    /// The `Transport` has disconnected from the server.
    case closed
    
}
