//
//  OutgoingMessage.swift
//  SwiftPhoenixClient
//
//  Created by Daniel Rees on 1/27/25.
//  Copyright © 2025 SwiftPhoenixClient. All rights reserved.
//

import Foundation

import Foundation

///
/// Defines a message that originates from the client and is being sent to the Server.
///
/// The message will be encoded into following shape before being sent
///
///     [join_ref,ref,topic,event,payload]
///
///
public struct OutgoingMessage {
        
    public let joinRef: String?
    public let ref: String?
    public let topic: String
    public let event: String
    public let payload: OutgoingPayload
    
    internal var isBinary: Bool {
        switch payload {
        case .binary(_): return true
        default: return false
        }
    }
}

extension OutgoingMessage {
    init(heartbeatRef: String) {
        self.init(
            joinRef: nil,
            ref: heartbeatRef, 
            topic: "phoenix",
            event: ChannelEvent.heartbeat,
            payload: .json([:])
        )
    }
}

public enum OutgoingPayload {
    case binary(Data)
    case encodable(Encodable)
    case json(Any)
}

