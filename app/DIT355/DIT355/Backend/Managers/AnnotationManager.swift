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
    
    //MARK: - Class Variables
    static let shared = AnnotationManager()
    var annotations = [Annotation]()
    private lazy var sessionsCount = 0
    var sessionSize = 98
    var isLoggingSessions = false
    
    //MARK: - Composed Objects
    private lazy var mc = MapController.shared
    
    //MARK: - Constructor
    private init(){}
    
    //MARK: - Class Functions
    /// Convert a json string to a Request struct.
    func toStruct(_ str: String){
        let jsonData  = JSON(parseJSON: str)
        self.toAnnotations(Request(obj: jsonData))
    }
    /// Convert a Request struct to two annotations.
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
    /// Coordinate the annotations based on the logging mode.
    func checkModes(_ anns: [Annotation]){
        if isLoggingSessions {
            (0..<anns.count).forEach { (i) in
                self.annotations.append(anns[i])
            }
            if self.annotations.count > self.sessionSize {
                let title = "Session: \(self.sessionsCount + 1)"
                let s = Session(title: title, date: Date(), anns: self.annotations)
                self.annotations.removeAll()
                self.sessionsCount += 1
                NotificationCenter.default.post(name: Notification.Name(rawValue:"reloadData"), object: nil, userInfo: ["session" : s])
            }
        } else {
            for ann in anns {
                mc.addAnnotations(ann)
            }
        }
       
    }
    
}
