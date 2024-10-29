//
//  SocketTest.swift
//  SwiftPhoenixClientTests
//
//  Created by Daniel Rees on 10/28/24.
//  Copyright © 2024 SwiftPhoenixClient. All rights reserved.
//

import Testing
@testable import SwiftPhoenixClient

struct SocketTest {
    
    // MARK: -- constructor --
    @Test func constructor_sets_defaults() async throws {
        let socket = Socket("wss://localhost:4000/socket")
        
        #expect(socket.channels.count == 0)
        #expect(socket.sendBuffer.count == 0)
        #expect(socket.ref == 0)
        #expect(socket.endPoint == "wss://localhost:4000/socket")
        #expect(socket.stateChangeCallbacks.open.isEmpty)
        #expect(socket.stateChangeCallbacks.close.isEmpty)
        #expect(socket.stateChangeCallbacks.error.isEmpty)
        #expect(socket.stateChangeCallbacks.message.isEmpty)
        #expect(socket.timeout == Defaults.timeoutInterval)
        #expect(socket.heartbeatInterval == Defaults.heartbeatInterval)
    }
    
    @Test func constructor_supports_closure_or_literal_params() async throws {
        let literalSocket = Socket("wss://localhost:4000/socket", params: ["one": "two"])
        #expect(literalSocket.params?["one"] as? String == "two")
        
        var authToken = "abc123"
        let closueSocket = Socket("wss://localhost:4000/socket", params: { ["token": authToken] } )
        #expect(closueSocket.params?["token"] as? String == "abc123")
        
        authToken = "xyz987"
        #expect(closueSocket.params?["token"] as? String == "xyz987")
    }
    
    // MARK: -- websocketProtocol --
    @Test func websocketProtocol_returns_wss_when_given_https() async throws {
        let socket = Socket("https://example.com/")
        #expect(socket.websocketProtocol == "wss")
    }
    
    @Test func websocketProtocol_returns_wss_when_given_wss() async throws {
        let socket = Socket("wss://example.com/")
        #expect(socket.websocketProtocol == "wss")
    }
    
    @Test func websocketProtocol_returns_ws_when_given_http() async throws {
        let socket = Socket("http://example.com/")
        #expect(socket.websocketProtocol == "ws")
    }
    
    @Test func websocketProtocol_returns_ws_when_given_ws() async throws {
        let socket = Socket("ws://example.com/")
        #expect(socket.websocketProtocol == "ws")
    }
    
    @Test func websocketProtocol_returns_nil_if_there_is_no_schema() async throws {
        let socket = Socket("example.com/")
        #expect(socket.websocketProtocol == "ws")
    }
    
    // MARK: -- endPointUrl --
    @Test func endPointUrl_constructs_valid_url() async throws {
        // Full URL
        #expect(Socket("wss://example.com/websocket")
            .endPointUrl.absoluteString == "wss://example.com/websocket?vsn=2.0.0")
        
        // Appends `/websocket`
        #expect(Socket("https://example.com/chat")
            .endPointUrl.absoluteString == "wss://example.com/chat/websocket?vsn=2.0.0")
        
        // Appends `/websocket`, accounting for trailing `/`
        #expect(Socket("ws://example.com/chat/")
            .endPointUrl.absoluteString == "ws://example.com/chat/websocket?vsn=2.0.0")
        
        // Appends `params`
        #expect(Socket("http://example.com/chat", params: ["token": "abc123"])
            .endPointUrl.absoluteString == "ws://example.com/chat/websocket?vsn=2.0.0&token=abc123")
    }
}
