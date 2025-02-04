//
//  SocketTest.swift
//  SwiftPhoenixClientTests
//
//  Created by Daniel Rees on 10/28/24.
//  Copyright © 2024 SwiftPhoenixClient. All rights reserved.
//

import Foundation
import Testing
@testable import SwiftPhoenixClient

struct SocketTest {
    
    private func setupSocket(readyState: TransportReadyState = .closed,
                             endpoint: String = "/socket") -> (Socket, TransportMock) {
        let mockTransport = TransportMock()
        mockTransport.readyState = readyState
        
        let socket = Socket(endPoint: endpoint) { _ in return mockTransport }
        
        return (socket, mockTransport)
    }
    
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
    
    // MARK: -- connectWithWebsocket ---
    @Test func connectWithWebsocket_establishes_websocket_connection_with_endpoint() {
        let (socket, _) = setupSocket()
        
        socket.connect()
        #expect(socket.connection != nil)
    }
    
    @Test func connectWithWebsocket_sets_callbacks_for_connection() {
        let (socket, mockTransport) = setupSocket()

        var open = 0
        socket.onOpen { open += 1 }
        
        var close = 0
        socket.onClose { close += 1 }
        
        var lastError: Error?
        socket.onError { error, _ in
            lastError = error
        }
        
        var lastMessage: IncomingMessage?
        socket.onMessage(callback: { (message) in
                lastMessage = message
            }
        )
        
        mockTransport.readyState = .closed
        socket.connect()
        
        mockTransport.delegate?.onOpen(response: nil)
        mockTransport.delegate?.onClose(code: .normalClosure, reason: nil)
        mockTransport.delegate?.onError(error: TestError.stub, response: nil)
        
        let text = """
        [null,null,"topic","event","payload"]
        """
        mockTransport.delegate?.onMessage(string: text)

        // Delegate implementations all runs `.async` which cause there to be a
        // slight out-of-ordering. Sleep 1 second to let everything hit
        Thread.sleep(forTimeInterval: 0.05) // syncarray runs on .async
        #expect(open == 1)
        #expect(close == 1)
        #expect(lastError != nil)
        
        let parser = JsonPayloadParser()
        let parseResult = parser.parse(lastMessage!,
                                       payloadDecoder: socket.decoder,
                                       payloadEncoder: socket.encoder)
        let payload = try! parseResult.get() as! String
        #expect(payload == "payload")
    }
    
    @Test func connectWithWebsocket_does_not_connect_if_already_connected() {
        let (socket, mockTransport) = setupSocket()
        
        socket.connect()
        mockTransport.readyState = .open
        
        socket.connect()
        
        #expect(mockTransport.connectWithCallsCount == 1)
    }
    
    // TODO: Long Poll
    // MARK: -- connectWithLongPoll ---
    
    @Test func disconnect_removes_existing_connection() async throws {
        let (socket, mockTransport) = setupSocket()
        
        socket.connect()
        socket.disconnect()
        
        #expect(socket.connection == nil)
        #expect(mockTransport.disconnectCodeReasonReceivedArguments?.code
                == URLSessionWebSocketTask.CloseCode.normalClosure)
    }
    
    @Test func disconnect_calls_callback() async throws {
        let (socket, mockTransport) = setupSocket()
        socket.connect()
    
        var count = 0
        socket.disconnect(code: .goingAway) {
            count += 1
        }
        
        #expect(mockTransport.disconnectCodeReasonCalled)
        #expect(mockTransport.disconnectCodeReasonReceivedArguments?.code == .goingAway)
        #expect(mockTransport.disconnectCodeReasonReceivedArguments?.reason == nil)
        #expect(count == 1)
    }
    
    @Test func disconnect_calls_onClose_state_callbacks() async throws {
        let (socket, _) = setupSocket()
        
        var count =  0
        socket.onClose {
            count += 1
        }
        
        socket.disconnect()
        #expect(count == 1)
    }
    
    @Test func disconnect_invalidates_the_heartbeat_timer() async throws {
        let (socket, _) = setupSocket()
        
        var count = 0
        let queue = DispatchQueue(label: "test.heartbeat")
        let timer = HeartbeatTimer(timeInterval: 10, queue: queue)
        
        timer.start { count += 1 }
        
        socket.heartbeatTimer = timer
        
        socket.disconnect()
        #expect(socket.heartbeatTimer?.isValid == false)
        timer.fire()
        #expect(count == 0)
    }
    
    @Test func disconnect_does_nothing_if_not_connected() async throws {
        let (socket, mockTransport) = setupSocket()
        
        socket.disconnect()
        #expect(mockTransport.disconnectCodeReasonCalled == false)
    }
    
    // MARK: -- isConnected & connectionState --
    @Test func connectionState_defaults_to_closed() async throws {
        let (socket, _) = setupSocket()
        #expect(socket.isConnected == false)
        #expect(socket.connectionState == .closed)
    }
    
    @Test func connectionState_returns_connecting() async throws {
        let (socket, _) = setupSocket(readyState: .connecting)
        socket.connect()
        
        #expect(socket.isConnected == false)
        #expect(socket.connectionState == .connecting)
    }
    
    @Test func connectionState_returns_open() async throws {
        let (socket, _) = setupSocket(readyState: .open)
        socket.connect()
        
        #expect(socket.isConnected == true)
        #expect(socket.connectionState == .open)
    }
    @Test func connectionState_returns_closing() async throws {
        let (socket, _) = setupSocket(readyState: .closing)
        socket.connect()
        
        #expect(socket.isConnected == false)
        #expect(socket.connectionState == .closing)
    }
    @Test func connectionState_returns_closed() async throws {
        let (socket, _) = setupSocket(readyState: .closed)
        socket.connect()
        
        #expect(socket.isConnected == false)
        #expect(socket.connectionState == .closed)
    }
    
    // MARK: -- channel --
    @Test func channel_returns_channel_with_given_topic_and_params() async throws {
        let (socket, _) = setupSocket()
        
        let channel = socket.channel("topic", params: ["one": "two"])
        #expect(channel.socket === socket)
        #expect(channel.topic == "topic")
        #expect(channel.params["one"] as? String == "two")
    }
    
    @Test func channel_adds_channel_to_sockets_channel_list() async throws {
        let (socket, _) = setupSocket()
    
        #expect(socket.channels.isEmpty)
        
        let channel = socket.channel("topic", params: ["one": "two"])
        #expect(socket.channels.count == 1)
        #expect(socket.channels.first === channel)
    }
    
    // MARK: -- remove --
    @Test func remove_removes_given_channel_from_channels() throws {
        let (socket, _) = setupSocket()
        
        let channel1 = socket.channel("topic-1")
        let channel2 = socket.channel("topic-2")
        
        
        channel1.joinPush.ref = "1"
        channel2.joinPush.ref = "2"
        
        Thread.sleep(forTimeInterval: 0.1) // syncarray runs on .async
        #expect(socket.stateChangeCallbacks.open.count == 2)
        
        socket.remove(channel1)
        Thread.sleep(forTimeInterval: 0.1) // syncarray runs on .async
        #expect(socket.stateChangeCallbacks.open.count == 1)
        
        #expect(socket.channels.count == 1)
        #expect(socket.channels.first === channel2)
    }
    
    // MARK: -- push --
    @Test func push_sends_string_to_connection_when_conneted() throws {
        let (socket, mockTransport) = setupSocket()
        
        socket.connect()
        mockTransport.readyState = .open
        
        let outgoing = buildOutgoingMessage(ref: "ref",
                                            topic: "topic",
                                            event: "event",
                                            payload: .json("payload"))
        socket.push(outgoing: outgoing)
        #expect(mockTransport.sendStringCalled)
        let actual = mockTransport.sendStringReceivedString
        
        let expected = """
        [null,"ref","topic","event","payload"]
        """
        
        #expect(actual == expected)
    }
    
    @Test func push_sends_binary_when_connected() async throws {
        let (socket, mockTransport) = setupSocket()
        
        socket.connect()
        mockTransport.readyState = .open
        
        let outgoing = buildOutgoingMessage(joinRef: "0",
                                            ref: "1",
                                            topic: "t",
                                            event: "e",
                                            payload: .binary(Data([0x01])))
        socket.push(outgoing: outgoing)
        #expect(mockTransport.sendDataCalled)
        let data = mockTransport.sendDataReceivedData!
        let actual = [UInt8](data)
        let expected: [UInt8] = [0x00, 0x01, 0x01, 0x01, 0x01]
        + "01te".utf8.map { UInt8($0) }
        + [0x01]
        
        
        #expect(actual == expected)
    }
    
    @Test func push_buffers_messages_when_not_conneted() throws {
        let (socket, mockTransport) = setupSocket()
        socket.connect()
        #expect(socket.sendBuffer.isEmpty)
        
        let outgoing = buildOutgoingMessage(ref: "ref",
                                            topic: "topic",
                                            event: "event",
                                            payload: .json("payload"))
        socket.push(outgoing: outgoing)
        #expect(mockTransport.sendStringCalled == false)
        #expect(mockTransport.sendDataCalled == false)
        Thread.sleep(forTimeInterval: 0.05) // syncarray runs on .async
        #expect(socket.sendBuffer.count == 1)
        
        socket.sendBuffer.forEach( { try? $0.callback() } )
        #expect(mockTransport.sendStringCallsCount == 1)
        let actual = mockTransport.sendStringReceivedString
        
        let expected = """
        [null,"ref","topic","event","payload"]
        """
        
        #expect(actual == expected)
    }
    
    // MARK: -- makeRef --
    @Test func makeRef_returns_next_message_ref() throws {
        let (socket, _) = setupSocket()
        
        #expect(socket.ref == 0)
        #expect(socket.makeRef() == "1")
        #expect(socket.ref == 1)
        #expect(socket.makeRef() == "2")
        #expect(socket.ref == 2)
    }
    
    @Test func makeRef_resets_after_overflow() async throws {
        let (socket, _) = setupSocket()
        socket.ref = UInt64.max
        
        #expect(socket.makeRef() == "0")
        #expect(socket.ref == 0)
    }
    
    // MARK: -- sendHeartbeat --
    @Test func sendHeartbeat_closes_socket_if_heartbeat_not_ackd_within_window() throws {
//        let (socket, mockTransport) = setupSocket()
//        
//        var closed = false
//        socket.connect()
//        mockTransport.readyState = .open
        
        // TODO: Can timers be converted to task sleep with fake clock?
    }
    
    @Test func sendHeartbeat_pushes_heartbeat_data_when_connected() async throws {
        let (socket, mockTransport) = setupSocket()
        socket.connect()
        mockTransport.readyState = .open
        
        socket.sendHeartbeat()
    
        #expect(mockTransport.sendStringCalled == true)
        let actual = mockTransport.sendStringReceivedString
        
        let expected = """
        [null,"\(socket.pendingHeartbeatRef!)","phoenix","heartbeat",{}]
        """
        
        #expect(actual == expected)
    }
    
    @Test func sendHeartbeat_does_nothing_when_not_connected() throws {
        let (socket, mockTransport) = setupSocket()
        socket.sendHeartbeat()
        
        #expect(mockTransport.disconnectCodeReasonCalled == false)
        #expect(mockTransport.sendDataCalled == false)
        #expect(mockTransport.sendStringCalled == false)
    }

    // MARK: -- flushSendBuffer --
    @Test func flushSendBuffer_calls_callbacks_in_buffer_when_connected() throws {
        let (socket, mockTransport) = setupSocket()
        socket.connect()
        mockTransport.readyState = .open
        
        var oneCalled = 0
        socket.sendBuffer.append(("0", { oneCalled += 1 }))
        var twoCalled = 0
        socket.sendBuffer.append(("1", { twoCalled += 1 }))
        let threeCalled = 0

        socket.flushSendBuffer()
        #expect(oneCalled == 1)
        #expect(twoCalled == 1)
        #expect(threeCalled == 0)
    }
    
    @Test func flushSendBuffer_empties_send_buffer() throws {
        let (socket, mockTransport) = setupSocket()
        socket.connect()
        mockTransport.readyState = .open
        
        socket.sendBuffer.append(("0", { }))
        
        Thread.sleep(forTimeInterval: 0.15) // syncarray runs on .async
        #expect(socket.sendBuffer.count == 1)
        
        socket.flushSendBuffer()
        Thread.sleep(forTimeInterval: 0.05) // syncarray runs on .async
        #expect(socket.sendBuffer.count == 0)
    }
    
    // MARK: -- removeFromSendBuffer --
    @Test func removeFromSendBuffer_removes_a_callback_with_a_matching_ref() async throws {
        let (socket, mockTransport) = setupSocket()
        socket.connect()
        mockTransport.readyState = .open
        
        var oneCalled = 0
        socket.sendBuffer.append(("0", { oneCalled += 1 }))
        var twoCalled = 0
        socket.sendBuffer.append(("1", { twoCalled += 1 }))
        let threeCalled = 0
        
        socket.connect()
        mockTransport.readyState = .open
        
        socket.removeFromSendBuffer(ref: "0")
        
        socket.flushSendBuffer()
        #expect(oneCalled == 0)
        #expect(twoCalled == 1)
        #expect(threeCalled == 0)
    }
    
    // MARK: -- onConnectionOpen --
    @Test func onConnectionOpen_flushes_the_send_buffer() throws {
        let (socket, mockTransport) = setupSocket()
        
        var oneCalled = 0
        socket.sendBuffer.append(("0", { oneCalled += 1 }))
        
        socket.connect()
        mockTransport.readyState = .open
        
        socket.onConnectionOpen(response: nil)
        Thread.sleep(forTimeInterval: 0.1) // syncarray runs on .async
        #expect(socket.sendBuffer.isEmpty)
    }
    
    @Test func onConnectionOpen_resets_reconnect_timer() throws {
        let (socket, mockTransport) = setupSocket()
        
        var oneCalled = 0
        socket.sendBuffer.append(("0", { oneCalled += 1 }))
        
        socket.connect()
        mockTransport.readyState = .open
        
        socket.onConnectionOpen(response: nil)
        Thread.sleep(forTimeInterval: 0.1) // syncarray runs on .async
        #expect(socket.sendBuffer.isEmpty)
    }
}
