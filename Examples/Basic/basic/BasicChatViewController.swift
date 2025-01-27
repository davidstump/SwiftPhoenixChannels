//
//  BasicChatViewController.swift
//  Basic
//
//  Created by Daniel Rees on 10/23/20.
//  Copyright © 2021 SwiftPhoenixClient. All rights reserved.
//

import UIKit
import SwiftPhoenixClient

/*
 Testing with Basic Chat
 
 This class is designed to provide as a sandbox to test various client features in a "real"
 environment where network can be dropped, disconnected, servers can quit, etc.
 
 For a more advanced example, see the ChatRoomViewController
 
 This example is intended to connect to a local chat server.
 
 Setup
 1. Select which Transpart is being tested.
 
 Steps
 1. Connect the Socket
 2. Verify System pings come through
 3. Send a message and verify it is returned by the server
 4. From a web client, send a message and verify it is received by the app.
 5. Disconnect and Connect the Socket again
 6. Kill the server, verifying that the retry starts
 7. Start the server again, verifying that the client reconnects
 8. After the client reconnects, verify pings and messages work as before
 9. Disconnect the client and kill the server again
 10. While the server is disconnected, connect the client
 11. Start the server and verify that the client connects once the server is available
 
 */

let endpoint = "http://localhost:4000/socket/websocket"

class BasicChatViewController: UIViewController {
    
    // MARK: - Child Views
    
    @IBOutlet weak var connectButton: UIButton!
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var chatWindow: UITextView!
    
    
    // MARK: - Variables
    let username: String = "Basic"
    var topic: String = "rooms:lobby"
    
    
    
    // Test the URLSessionTransport
    let socket = Socket(endpoint)
    
    var lobbyChannel: Channel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chatWindow.text = ""
        
        // Blocks passed to onOpen (or other methods that take a callback) must not retain self,
        // as this will create a retain cycle and leak
        socket.onOpen { [weak self] in
            guard let self else { return }
            
            self.addText("Socket Opened")
            DispatchQueue.main.async {
                self.connectButton.setTitle("Disconnect", for: .normal)
            }
        }
        
        socket.onClose { [weak self] in
            guard let self else { return }

            self.addText("Socket Closed")
            DispatchQueue.main.async {
                self.connectButton.setTitle("Connect", for: .normal)
            }
        }
        
        socket.onError { [weak self] (error, response) in
            guard let self else { return }

            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode > 400 {
                self.addText("Socket Errored: \(statusCode)")
                self.socket.disconnect()
            } else {
                self.addText("Socket Errored: " + error.localizedDescription)
            }
        }
        
        socket.logger = { msg in print("LOG:", msg) }
        
    }
    
    
    // MARK: - IBActions
    @IBAction func onConnectButtonPressed(_ sender: Any) {
        if socket.isConnected {
            disconnectAndLeave()
            
        } else {
            connectAndJoin()
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        let payload = ["user": username, "body": messageField.text!]
        
        self.lobbyChannel
            .push("new:msg", payload: payload)
            .receive("ok") { (message) in
                print("success", message)
            }
            .receive("error") { (errorMessage) in
                print("error: ", errorMessage)
            }
        
        messageField.text = ""
    }
    
    
    private func disconnectAndLeave() {
        //     Be sure the leave the channel or call socket.remove(lobbyChannel)
        lobbyChannel.leave()
        socket.disconnect {
            self.addText("Socket Disconnected")
        }
    }
    
    private func connectAndJoin() {
        let channel = socket.channel(topic, params: ["status":"joining"])
        

        channel.on("join").message { [weak self] _ in
            self?.addText("You joined the room.")
        }
        
        channel.on("new:msg").messageDecodable(of: Chat.self, { [weak self] message in
            guard let self else { return }
            
            switch message.payload {
            case .success(let chat):
                let newMessage = "[\(chat.username)] \(chat.body)"
                self.addText(newMessage)
                
            case .failure(let error):
                print("new:msg parse failure: ", error)
            }
        })
        
        channel.on("user:entered").message { [weak self] message in
            print(message.payload)
            self?.addText("[anonymous entered]")
        }
        
        self.lobbyChannel = channel
        
        
        self.lobbyChannel
            .join()
            .receive("ok") { [weak self] _ in
                self?.addText("Joined Channel")
            }.receive("error") { [weak self] message in
                self?.addText("Failed to join channel: \(message.payload)")
            }
        self.socket.connect()
    }
    
    private func addText(_ text: String) {
        DispatchQueue.main.async {
            let updatedText = self.chatWindow.text.appending(text).appending("\n")
            self.chatWindow.text = updatedText
            
            let bottom = NSMakeRange(updatedText.count - 1, 1)
            self.chatWindow.scrollRangeToVisible(bottom)
        }
    }
    
}

struct Chat: Codable {
    let username: String
    let body: String
}
