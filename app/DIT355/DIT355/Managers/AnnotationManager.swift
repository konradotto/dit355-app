//
//  ConversionManager.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-27.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

class AnnotationManager {
    
    static let shared = AnnotationManager()
    var annotations = [Annotation]()
    private lazy var sessionsCount = 0
    private let sessionSize = 98
    //private lazy var sm = SessionManager.shared
    private lazy var mc = MapController.shared
    var isInteractiveMode : Bool!
    
    private init(){}
    
    func toStruct(_ str: String){
        
        let jsonData  = JSON(parseJSON: str)
        self.toAnnotations(Request(obj: jsonData))
    }
    
    
    func toAnnotations(_ rm : Request){
       
        //need to convert the timeinterval tho
        var anns = [Annotation]()
        anns.append(Annotation(title: "Source",
                                      coordinate: CLLocationCoordinate2D(latitude: rm.originLat, longitude: rm.originLong),
                                      purpose: rm.purpose,
                                      type: rm.type,
                                      depTime: rm.departureTime,
                                      id: rm.id))
        anns.append(Annotation(title: "Destination",
                                      coordinate: CLLocationCoordinate2D(latitude: rm.destinationLat, longitude: rm.destinationLong),
                                      purpose: rm.purpose,
                                      type: rm.type,
                                      depTime: rm.departureTime,
                                      id: rm.id))
        
        checkModes(anns)
    }
 
  
    
    
    func checkModes(_ anns: [Annotation]){
        
        if isInteractiveMode {
            (0..<anns.count).forEach { (i) in
                self.annotations.append(anns[i])
            }
            if self.annotations.count > self.sessionSize {
                let title = "Session: \(self.sessionsCount + 1)"
                let s = Session(title: title, date: Date(), anns: self.annotations)
                //sm.sessions.append(s)
                self.annotations.removeAll()
                self.sessionsCount += 1
                NotificationCenter.default.post(name: Notification.Name(rawValue:"reloadData"), object: nil, userInfo: ["session" : s])
                //print("session init")
            }
        } else { // prolly async
            for ann in anns {
                mc.addAnnotations(ann)
            }
        }
       
    }
    
    
//    func dummyRequests(){
//
//        print("dummyRequests started")
//        let minLat = 57.562184, minLong = 11.7018663, maxLat = 57.8580397, maxLong = 12.2068462
//
//        (0..<51).forEach { (i) in
//            let originRandomLat = Double.random(in: minLat...maxLat)
//            let originRandomLong = Double.random(in: minLong...maxLong)
//            let targetRandomLat = Double.random(in: minLat...maxLat)
//            let targetRandomLong = Double.random(in: minLong...maxLong)
//            let type = ["bus","tram","ferry"].randomElement()
//            let req = Request(deviceId: String("deviceId"), requestId: String("requestId"), sourceLat: originRandomLat, sourceLong: originRandomLong, destinationLat: targetRandomLat, destinationLong: targetRandomLong, departureTime: 2000.005, purpose: "purpose", type: type!)
//            toAnnotations(req)
//
//        }
//
//
//
//    }
   
    
}
