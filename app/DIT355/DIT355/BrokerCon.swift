//
//  BrokerCon.swift
//  DIT355
//
//  Created by Kardo Dastin on 2019-11-11.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import SwiftMQTT

class BrokerCon: MQTTSessionDelegate{
    
    
    static let shared = BrokerCon()
    
    private init() {
        establishConnection()
    }
    
    // Protocol 1
    func mqttDidReceive(message: MQTTMessage, from session: MQTTSession) {
        print("data received on topic \(message.topic) message \(message.stringRepresentation ?? "<>")")
    }
    
    // Protocol 2
    func mqttDidDisconnect(session: MQTTSession, error: MQTTSessionError) {
        print("Session Disconnected.")
        if error != .none {
            print(error.description)
        }
    }
    
    // Protocol 3
    func mqttDidAcknowledgePing(from session: MQTTSession) {
        print("Keep-alive ping acknowledged.")
    }
   
    var mqttSession: MQTTSession!
    

    //establish a connection with the broker through the specified host, port, and ID
    func establishConnection() {
        let host = "localhost"
        let port: UInt16 = 1883
        let clientID = self.clientID()
    
        mqttSession = MQTTSession(host: host, port: port, clientID: clientID, cleanSession: true, keepAlive: 15, useSSL: false)
        mqttSession.delegate = self

        mqttSession.connect { (error) in
            if error == .none {
                print("Connected.")
                self.subscribeToChannel()
            } else {
                print("Error while establishing connection.")
            }
        }
    }
    
    // Subscribe to channel
    func subscribeToChannel() {
        let channel = "/#"
        mqttSession.subscribe(to: channel, delivering: .atLeastOnce) { (error) in
            if error == .none {
                print("Subscribed to \(channel)")
            } else {
                print("Error occurred during subscription:")
                print(error.description)
            }
        }
    }
    
    func clientID() -> String {

           let userDefaults = UserDefaults.standard
           let clientIDPersistenceKey = "clientID"
           let clientID: String

           if let savedClientID = userDefaults.object(forKey: clientIDPersistenceKey) as? String {
               clientID = savedClientID
           } else {
               clientID = randomStringWithLength(5)
               userDefaults.set(clientID, forKey: clientIDPersistenceKey)
               userDefaults.synchronize()
           }
           
           return clientID
       }
    func randomStringWithLength(_ len: Int) -> String {
           let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

           var randomString = String()
           for _ in 0..<len {
               let length = UInt32(letters.count)
               let rand = arc4random_uniform(length)
               let index = String.Index(encodedOffset: Int(rand))
               randomString += String(letters[index])
           }
           return String(randomString)
       }
    
}
