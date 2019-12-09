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
    var host = "192.168.0.100"
    var port: UInt16 = 1883
    var topic = "travel_requests"
    private var mqtt: CocoaMQTT?
    
    private lazy var unsubBanner = FloatingNotificationBanner(title: "Succefully subscribed to topic: \(topic)", subtitle: "tap to unsubscribe", style: .info)
    private lazy var initBanner  = FloatingNotificationBanner(title: "Succefully conntected to host: \(host)", subtitle: "tap to subscribe", style: .success)
    private lazy var subBanner   = FloatingNotificationBanner(title: "Succefully unsubscribed from topic: \(topic)", subtitle: "tap to re-subscribe", style:.warning)
    private lazy var reconBanner = FloatingNotificationBanner(title: "Disconntected from host: \(host)", subtitle: "tap to try re-connect", style: .danger)
    
    
    private init() {
        print(">> init connection")
        establishConnection()
        
        initBanner.autoDismiss  = false
        subBanner.autoDismiss   = false
        unsubBanner.autoDismiss = false
        reconBanner.autoDismiss = false
        
        
       
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
        
        reconBanner.onTap = {
            self.reconBanner.dismiss()
            self.establishConnection()
        }
        
    }
    
    
    func establishConnection() {
        let clientId = self.clientID()
        mqtt = CocoaMQTT(clientID: clientId, host: host, port: port)
        mqtt!.keepAlive = 30
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
        subBanner.dismiss()
        unsubBanner.dismiss()
        initBanner.dismiss()
        let _ = !reconBanner.isDisplaying ? (reconBanner.show(bannerPosition: .bottom)) : (())
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print(">> Did connect acknowledge")
        let _ = !initBanner.isDisplaying ? initBanner.show(bannerPosition: .bottom) : (())
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
        //let _ = !unsubBanner.isDisplaying ? unsubBanner.show(bannerPosition: .bottom) : (())
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        print(">> Did subscribe to topic: ",topic)
        let _ = !unsubBanner.isDisplaying ? unsubBanner.show(bannerPosition: .bottom) : (())
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print(">> Did unsubscribe from topic: ",topic)
        let _ = !subBanner.isDisplaying ? (subBanner.show(bannerPosition: .bottom)) : (())
    }
    
    
}
//extension MqttManager : NotificationBannerDelegate {
//    func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
//         print("banner will appear")
//    }
//
//    func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
//         print("banner did appear")
//    }
//
//    func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) {
//        print("banner will disappear")
//    }
//
//    func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) {
//         print("banner did disappear")
//    }
//
//
//}
