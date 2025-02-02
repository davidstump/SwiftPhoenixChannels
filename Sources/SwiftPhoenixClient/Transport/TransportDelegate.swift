//
//  TransportDelegate.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 2/2/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation

/// Delegate to receive notifications of events that occur in the `Transport` layer.
public protocol TransportDelegate {
    
    /// Notified when the `Transport` opens.
    ///
    /// - Parameter response: Response from the server indicating that the WebSocket
    ///     handshake was successful and the connection has been upgraded to webSockets
    func onOpen(response: URLResponse?)
    
    /// Notified when the `Transport` receives an error.
    ///
    /// - Parameter error: Client-side error from the underlying `Transport` implementation
    /// - Parameter response: Response from the server, if any, that occurred with the Error
    func onError(error: Error, response: URLResponse?)
    
    /// Notified when the `Transport` receives a string from the server.
    ///
    /// - Parameter string: String received from the server
    func onMessage(string: String)
    
    /// Notified when the `Transport` receives data from the server.
    ///
    /// - Parameter data: Data received from the server
    func onMessage(data: Data)
    
    /// Notified when the `Transport` closes.
    ///
    /// - Parameter code: Code that was sent when the `Transport` closed
    /// - Parameter reason: A concise human-readable prose explanation for the closure
    func onClose(code: URLSessionWebSocketTask.CloseCode, reason: String?)
}
