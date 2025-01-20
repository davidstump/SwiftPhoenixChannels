//
//  IntermediateDeserializedMessage.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 9/13/24.
//  Copyright © 2024 SwiftPhoenixClient. All rights reserved.
//

///
/// Represents a string message received from the Server that has been decoded
/// from the format
///
///     "[join_ref, ref, topic, event, payload]"
///
/// into a decodable structure. Will then further be converted into a `Message`
/// by the `Serializer` before being passed into the rest of the client.
///
struct InboundMessage: Decodable {
    let joinRef: String?
    let ref: String?
    let topic: String
    let event: String
    
    /// Payload is unique. If its a binary message, we know exactly the size of
    /// the payload and can easily grab it and set it as the payload without
    /// having to decode to a JsonElement and then encode back into data
    ///
    /// However, if its a text message, we can easily (and quickly) decode the
    /// header information (joinRef, ref, topic, event, status) using Codable
    /// but we cannot truncate the rest of the message as Data. To get JUST the
    /// Data of the remaining `payload`, we'd have to decode it into a JsonElement
    /// and then encode it back into data. This has a near 30x performance hit
    /// since we are going from text -> data -> json element -> data -> codable
    ///
    /// JsonSerialization is faster by converting from text -> data -> Any -> data
    /// but it has some issues of it's own, one being that float values may not
    /// decode back to their original precision. e.g. 1.1 turns into 1.100001
    ///
    /// Ideally, we _don't_ roundtrip from data -> JsonElement -> data, and in
    /// the case where the `channel.on` handler actually wants just the codable,
    /// we can skip the roundtrip entirely by just going data -> codable payload
    /// of type `T`. However this would require a lot of internal changes.
    ///
    /// So that leaves us with
    ///     * Binary messages are highly performant
    ///     * Text messages ending in a Codable can be highly performant
    ///     * Text messages with an Any or [String: Any] can be performant
    ///     * Text messages with Data payload suffer from poor perforamnce
    ///
    /// Binary payloads can be determined at the Serializer. Text payloads need
    /// to be determined at the `trigger` site. 
    
    
    
    let payload: JsonElement
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        joinRef = try? container.decode(String?.self)
        ref = try? container.decode(String?.self)
        topic = try container.decode(String.self)
        event = try container.decode(String.self)
        payload = try container.decode(JsonElement.self)
    }
}
