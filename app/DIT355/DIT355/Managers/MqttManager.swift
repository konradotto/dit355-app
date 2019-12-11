//
//  BrokerCon.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-27.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import CocoaMQTT
import NotificationBannerSwift

class MqttManager{
    
    
    static let shared = MqttManager()
    lazy var host = String()
    lazy var port = UInt16()
    lazy var topic = String()
    private var mqtt: CocoaMQTT?
    var isConnected = false
    var isSubscribed = false
    
    private lazy var subBanner = FloatingNotificationBanner(title: "Subscribed to topic", subtitle: "", style: .info)
    private lazy var initBanner  = FloatingNotificationBanner(title: "Connection established", subtitle: "", style: .success)
    private lazy var unsubBanner   = FloatingNotificationBanner(title: "Unsubscribed from topic", subtitle: "", style:.warning)
    private lazy var dissBanner = FloatingNotificationBanner(title: "Disconntected from host :(", subtitle: "", style: .danger)
    private lazy var errorBanner = FloatingNotificationBanner(title: "Connection error :(", subtitle: "try different host/port", style: .danger)
    private lazy var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 3)
    
    
    private init() {
    initBanners()
    }
    
    func initBanners(){
        self.initBanner.autoDismiss = true
        self.initBanner.duration = 2
        self.subBanner.autoDismiss = true
        self.subBanner.duration = 2
        self.unsubBanner.autoDismiss = true
        self.unsubBanner.duration = 2
        self.dissBanner.autoDismiss = true
        self.dissBanner.duration = 2
        self.errorBanner.autoDismiss = true
        self.errorBanner.duration = 2
        
    }
    
    func establishConnection(host: String, port: UInt16) -> Bool {
        print(">> init connection")
        let clientId = self.clientID()
        mqtt = CocoaMQTT(clientID: clientId, host: host, port: port)
        mqtt!.keepAlive = 30
        mqtt!.delegate = self
        let status = mqtt!.connect()
        if status {
            print(">> Connection established")
            print(">> Client ID: ",clientId)
            self.host = host
            self.port = port
            initBanner.subtitleLabel?.text = "host: \(host)"
            
        }
        else {
            print("Connection error")
            errorBanner.show()
        }
        return status
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
               let index = String.Index(utf16Offset: Int(rand), in: letters)
               randomString += String(letters[index])
           }
           return String(randomString)
       }
    
    func subscribeTopic(topic: String){
        print(">> subscribing to topic: ",topic)
        mqtt!.subscribe(topic, qos: .qos1)
        self.topic = topic
    }
    
    func unsubscribeTopic(topic: String){
        print(">> unsubscribing from topic: ",topic)
        mqtt!.unsubscribe(topic)
    }
    
    func disconnect(){
        mqtt!.disconnect()
    }
    
}

extension MqttManager : CocoaMQTTDelegate {
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print(">> Did ping")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print(">> Did receive pong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print(">> Did disconnect with error")
        NotificationCenter.default.post(name: Notification.Name(rawValue:"mqtt_status"), object: nil,userInfo: ["isConnected" : false])
        if err != nil { print(">> Error: ",err?.localizedDescription as Any) }
        self.isConnected = false
        dissBanner.subtitleLabel?.text = "host: \(host)"
        dissBanner.show()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print(">> Did connect acknowledge")
        NotificationCenter.default.post(name: Notification.Name(rawValue:"mqtt_status"), object: nil,userInfo: ["isConnected" : true])
        self.isConnected = true
        initBanner.show()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print(">> Did publish message")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print(">> Did publish acknowledge")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print(">> Did receive message")
        let _ =  message.string != nil ? print(">> Message topic: \(message.topic)\n Message string: \(message.string!)") :(())
        AnnotationManager.shared.toStruct(message.string!)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        print(">> Did subscribe to topic: ",topic)
        self.isSubscribed = true
        subBanner.subtitleLabel?.text = "topic: \(topic)"
        subBanner.show()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print(">> Did unsubscribe from topic: ",topic)
        self.isSubscribed = false
        unsubBanner.subtitleLabel?.text = "topic: \(topic)"
        unsubBanner.show()
    }
    
    
}
