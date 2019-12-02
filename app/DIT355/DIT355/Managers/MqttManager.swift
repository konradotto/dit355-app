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
    
    
    //"test.mosquitto.org", 1883, "some/test/planes"
    static let shared = MqttManager()
    private let host = "192.168.43.237"
    private let port: UInt16 = 1883
    private let topic = "travel_requests"
    private var mqtt: CocoaMQTT?
    
    private lazy var unsubBanner = NotificationBanner(title: "Receiving messages", subtitle: "tap to unsubscribe", style: .info)
    private lazy var initBanner = NotificationBanner(title: "Succefully conntected", subtitle: "tap to subscribe", style: .success)
    private lazy var subBanner = NotificationBanner(title: "Succefully unsubscribed", subtitle: "tap to re-subscribe", style:.warning)
    
    private init() {
        print(">> init connection")
        establishConnection()
        
        initBanner.autoDismiss = false
        subBanner.autoDismiss = false
        unsubBanner.autoDismiss = false
        
       
        initBanner.onTap = {
            self.initBanner.dismiss()
            self.subscribeTopic()
        }
        subBanner.onTap = {
            self.subBanner.dismiss()
            self.subscribeTopic()
        }
        unsubBanner.onTap = {
            self.unsubBanner.dismiss()
            self.unsubscribeTopic()
        }
    }
    
    
    func establishConnection() {
        let clientId = self.clientID()
        mqtt = CocoaMQTT(clientID: clientId, host: host, port: port)
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
        let _ = mqtt!.connect()
        print("Client ID: ",clientId)
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
        print(">> Did receive pong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print(">> Did disconnect")
        let _ = err != nil ? (print(">> Error: ",err.debugDescription)) :(())
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print(">> Did connect acknowledge")
        initBanner.show(bannerPosition: .bottom)
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
        let _ = !unsubBanner.isDisplaying ? unsubBanner.show(bannerPosition: .bottom) : (())
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        print(">> Did subscribe to topic: ",topic)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print(">> Did unsubscribe from topic: ",topic)
        subBanner.show(bannerPosition: .bottom)
    }
    
    
}
extension MqttManager : NotificationBannerDelegate {
    func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
         print("banner will appear")
    }
    
    func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
         print("banner did appear")
    }
    
    func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) {
        print("banner will disappear")
    }
    
    func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) {
         print("banner did disappear")
    }
    
    
}
