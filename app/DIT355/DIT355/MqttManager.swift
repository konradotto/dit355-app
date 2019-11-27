//
//  BrokerCon.swift
//  DIT355
//
//  Created by Kardo Dastin on 2019-11-11.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import CocoaMQTT

class MqttManager{
    
    
    static let shared = MqttManager()
    private let host = "test.mosquitto.org"
    private let port: UInt16 = 1883
    private let topic = "MainMachine120919/CP6706/TcIotCommunicator/Messages/103"
    private lazy var clientId = self.clientID()
    private var mqtt: CocoaMQTT?
    
    
    
    private init() {
        print(">> init")
        establishConnection()
    }
    
    
    func establishConnection() {
        
        mqtt = CocoaMQTT(clientID: clientId, host: host, port: port)
        //mqtt!.username = ""
        //mqtt!.password = ""
        //mqtt!.willMessage = CocoaMQTTMessage(topic: "/will", string: "dieout")
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
        let _ = mqtt!.connect()
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
    func subscribeTopic(){
        print(">> subscribing")
        mqtt!.subscribe(self.topic, qos: .qos1)
    }
    func unsubscribeTopic(){
        mqtt!.unsubscribe(self.topic)
    }
    
}

extension MqttManager : CocoaMQTTDelegate {
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print(">> Did ping")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print(">> Did receive ping")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print(">> Did disconnect")
        let _ = err != nil ? (print(">> Error: ",err.debugDescription)) :(())
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print(">> Did connect acknowledge")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print(">> Did publish message")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print(">> Did publish acknowledge")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print(">> Did receive message")
        let _ = message != nil && message.topic != nil && message.string != nil ? print(">> Message topic: \(message.topic)\nMessage string: \(String(describing: message.string))") :(())
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        print(">> Did subscribe to topic: ",topic)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print(">> Did unsubscribe from topic: ",topic)
    }
    
    
}
