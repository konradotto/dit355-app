//
//  AnnotationManager.swift
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
    var sessionsCount = 0
    var sessionSize = 98
    var isLoggingSessions = false {
        didSet {
            if !isLoggingSessions{
                sessionsCount = 0
            }
        }
    }
    
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
            if self.annotations.count == 0 && self.sessionsCount == 0 {
                mc.clearAnnotations(isSession: false)
            }
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
                mc.addAnnotations(ann, isRequest: true)
            }
        }
        
    }
    /// Read stops coordinates from the coordinates.txt file, convert them into doubles tuple array, then into CLLocationCoordinate2D array and finally trigger the stopsAnnotations() function.
    func readStopsCoordinates(){
        let path = Bundle.main.path(forResource: "coordinates", ofType: "txt")
        let all = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        let lines = all?.components(separatedBy: "\n")
        var doublesTuples = [(Double,Double)]()
        (0..<lines!.count-1).forEach { (i) in
            let lineArr = lines![i].components(separatedBy: " ")
            doublesTuples.append((Double(lineArr.first!)!,Double(lineArr.last!)!))
        }
        var coordinates = [CLLocationCoordinate2D]()
        for tup in doublesTuples {
            coordinates.append(CLLocationCoordinate2D(latitude: tup.0, longitude: tup.1))
        }
        stopsAnnotations(coordinates)
    }
    /// Convert a CLLocationCoordinate2D array into Annotations and trigger the MapController to plot them on the map.
    func stopsAnnotations(_ coords:[CLLocationCoordinate2D]){
        for coord in coords {
            let ann = Annotation(title: " ",
                                 coordinate: coord,
                                 purpose: "bus stop",
                                 type: "stop",
                                 depTime: Double(),
                                 id: "555")
            mc.addAnnotations(ann, isRequest: false)
        }
    }
    
}
