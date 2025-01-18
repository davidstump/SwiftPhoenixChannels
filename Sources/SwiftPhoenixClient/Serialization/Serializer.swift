//
//  PhoenixSerializer.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 2/23/24.
//  Copyright © 2024 SwiftPhoenixClient. All rights reserved.
//

/// Converts JSON received from the server into Messages and Messages into JSON to be sent to
/// the Server
public protocol Serializer {
    
    /// Encodes MessageV6 into a `String` to be sent back to a Phoenix server as raw text
    ///
    /// - parameter message: `MessageV6` with a json payload to encode
    /// - returns: Raw text to send back to the server
    func encode(message: Message) throws -> String
    
    ///
    /// Encodes a `MessageV6` into `Data` to be sent back to a Phoenix server as binary data
    ///
    /// - parameter message `SocketMessage` with a binary payload to encode
    /// - returns Binary data to send back to the server
    ///
    func binaryEncode(message: Message) -> Data
    
    /// Decodes a raw `String` from a Phoenix server into a `SocketMessage` structure
    /// Throws a `preconditionFailure` if passed a malformed message
    ///
    /// - parameter text: The raw `String` from a Phoenix server
    /// - returns: The `SocketMessage` created from the raw `String`
    /// - throws: `preconditionFailure` if the text could not be converted to a `SocketMessage`
    func decode(text: String) throws -> Message
    

    /// Decodes binary  `Data` from a Phoenix server into a `SocketMessage` structure
    ///
    /// - parameter data: The binary `Data` from a Phoenix server
    /// - returns The `SocketMessage` created from the raw `Data`
    /// - throws `preconditionFailure` if the data could not be converted to a `SocketMessage`
    func binaryDecode(data: Data) throws -> Message
    
}


///
/// The default implementation of [Serializer] for encoding and decoding messages. Matches the JS
/// client behavior. You can build your own if you'd like by implementing `Serializer` and passing
/// your custom Serializer to Socket
///
public class PhoenixSerializer: Serializer {
    
    private let HEADER_LENGTH: Int = 1
    private let META_LENGTH: Int = 4
    
    private let KIND_PUSH: UInt8 = 0
    private let KIND_REPLY: UInt8 = 1
    private let KIND_BROADCAST: UInt8 = 2
    
    private let payloadEncoder: PayloadEncoder
    private let payloadDecoder: PayloadDecoder
    
    init(payloadEncoder: PayloadEncoder = PhoenixPayloadEncoder(),
         payloadDecoder: PayloadDecoder = PhoenixPayloadDecoder()) {
        self.payloadEncoder = payloadEncoder
        self.payloadDecoder = payloadDecoder
    }
    
    public func encode(message: Message) throws -> String {
        guard let json = try payloadDecoder.decode(from: message.payload) as? [String: Any] else {
            throw PhxError.serializerError(reason: .decodingPayloadFailed)
        }
        
        let serverMessage = IntermediateMessage(
            joinRef: message.joinRef,
            ref: message.ref,
            topic: message.topic,
            event: message.event,
            payload: json
        )
        
        let data = try payloadEncoder.encode(any: serverMessage.toJSONObject())
        
        guard let encoded = String(data: data, encoding: .utf8) else {
            throw PhxError.serializerError(reason: .stringFromDataFailed(string: "encode(message:)"))
        }
        
        return encoded
    }
    
    public func binaryEncode(message: Message) -> Data {
        var byteArray: [UInt8] = []
        
        // Add the KIND, which is always a PUSH from the client to the server
        byteArray.append(KIND_PUSH)
        
        // Add the lengths of each piece of the message
        byteArray.append(UInt8(message.joinRef?.utf8.count ?? 0) )
        byteArray.append(UInt8(message.ref?.utf8.count ?? 0) )
        byteArray.append(UInt8(message.topic.utf8.count) )
        byteArray.append(UInt8(message.event.utf8.count) )
        
        
        // Add the message's meta fields + payload
        if let joinRef = message.joinRef {
            byteArray.append(contentsOf: joinRef.utf8.map { UInt8($0) })
        }
        
        if let ref = message.ref {
            byteArray.append(contentsOf: ref.utf8.map { UInt8($0) })
        }
        
        byteArray.append(contentsOf: message.topic.utf8.map { UInt8($0) })
        byteArray.append(contentsOf: message.event.utf8.map { UInt8($0) })
        byteArray.append(contentsOf: message.payload)
        
        return Data(byteArray)
    }
    
    
    public func decode(text: String) throws -> Message {
        guard
            let jsonData = text.data(using: .utf8)
        else {
            throw PhxError.serializerError(reason: .dataFromStringFailed(string: text))
        }
        
        guard let inboundMessageArray = try payloadDecoder.decode(from: jsonData) as? [Any] else {
            throw PhxError.serializerError(reason: .invalidStructure(string: text))
        }
        
        let inboundMessage = try IntermediateMessage(inboundMessageArray)
        
        // For phx_reply events, parse the payload from {"response": payload, "status": "ok"}.
        // Note that `payload` can be any primitive or another object
        if inboundMessage.event == ChannelEvent.reply {
            guard
                let payload = inboundMessage.payload as? [String: Any],
                let response = payload["response"],
                let status = payload["status"] as? String
            else {
                throw PhxError.serializerError(reason: .invalidReplyStructure(string: text))
            }
            
            return Message.reply(
                joinRef: inboundMessage.joinRef,
                ref: inboundMessage.ref,
                topic: inboundMessage.topic,
                status: status,
                payload: try payloadEncoder.encode(any: response)
            )
        } else if inboundMessage.joinRef != nil || inboundMessage.ref != nil {
            return Message.message(
                joinRef: inboundMessage.joinRef,
                ref: inboundMessage.ref,
                topic: inboundMessage.topic,
                event: inboundMessage.event,
                payload: try payloadEncoder.encode(any: inboundMessage.payload)
            )
        } else {
            return Message.broadcast(
                topic: inboundMessage.topic,
                event: inboundMessage.event,
                payload: try payloadEncoder.encode(any: inboundMessage.payload)
            )
        }
    }
    
    
    public func binaryDecode(data: Data) throws -> Message {
        let binary = [UInt8](data)
        return switch binary[0] {
        case KIND_PUSH: try decodePush(buffer: binary)
        case KIND_REPLY: try decodeReply(buffer: binary)
        case KIND_BROADCAST: try decodeBroadcast(buffer: binary)
        default:
            throw PhxError.serializerError(reason:
                    .invalidBinaryKind(string: "Expected binary data to include a KIND of push, reply, or broadcast. Got \(binary[0])")
            )
        }
    }
    
    // MARK: - Private -
    private func decodePush(buffer: [UInt8]) throws -> Message {
        let joinRefSize = Int(buffer[1])
        let topicSize = Int(buffer[2])
        let eventSize = Int(buffer[3])
        var offset = HEADER_LENGTH + META_LENGTH - 1 // pushes have no ref
        
        let joinRef = String(bytes: buffer[offset ..< offset + joinRefSize], encoding: .utf8)
        offset += joinRefSize
        guard let topic = String(bytes: buffer[offset ..< offset + topicSize], encoding: .utf8) else {
            throw PhxError.serializerError(reason: .decodeMissingTopic)
        }
        offset += topicSize
        guard let event = String(bytes: buffer[offset ..< offset + eventSize], encoding: .utf8) else {
            throw PhxError.serializerError(reason: .decodeMissingEvent)
        }
        offset += eventSize
        let data = Data(buffer[offset ..< buffer.count])
        
        return Message.message(
            joinRef: joinRef,
            ref: nil,
            topic: topic,
            event: event,
            payload: data
        )
    }
    
    private func decodeReply(buffer: [UInt8]) throws -> Message {
        let joinRefSize = Int(buffer[1])
        let refSize = Int(buffer[2])
        let topicSize = Int(buffer[3])
        let eventSize = Int(buffer[4])
        var offset = HEADER_LENGTH + META_LENGTH
        
        let joinRef = String(bytes: buffer[offset ..< offset + joinRefSize], encoding: .utf8)
        offset += joinRefSize
        let ref = String(bytes: buffer[offset ..< offset + refSize], encoding: .utf8)
        offset += refSize
        guard let topic = String(bytes: buffer[offset ..< offset + topicSize], encoding: .utf8) else {
            throw PhxError.serializerError(reason: .decodeMissingTopic)
        }
        offset += topicSize
        guard let event = String(bytes: buffer[offset ..< offset + eventSize], encoding: .utf8) else {
            throw PhxError.serializerError(reason: .decodeMissingEvent)
        }
        offset += eventSize
        let data = Data(buffer[offset ..< buffer.count])
        
        // for binary messages, payload = {status: event, response: data}
        return Message.reply(
            joinRef: joinRef,
            ref: ref,
            topic: topic,
            status: event,
            payload: data
        )
    }
    
    private func decodeBroadcast(buffer: [UInt8]) throws -> Message {
        let topicSize = Int(buffer[1])
        let eventSize = Int(buffer[2])
        var offset = HEADER_LENGTH + 2
        
        guard let topic = String(bytes: buffer[offset ..< offset + topicSize], encoding: .utf8) else {
            throw PhxError.serializerError(reason: .decodeMissingTopic)
        }
        offset += topicSize
        guard let event = String(bytes: buffer[offset ..< offset + eventSize], encoding: .utf8) else {
            throw PhxError.serializerError(reason: .decodeMissingEvent)
        }
        offset += eventSize
        let data = Data(buffer[offset ..< buffer.count])
        
        return Message.broadcast(
            topic: topic,
            event: event,
            payload: data
        )
    }
}
