//
//  Request.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-11.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import CoreLocation

struct RequestModel {
    
    var sourceLat       : Double
    var sourceLong      : Double
    var destinationLat  : Double
    var destinationLong : Double
    var departureTime   : TimeInterval
    var arrivalTime     : TimeInterval?
    var hasArrivalTime  : Bool
    var type            : Int
    
    var description: String {
        get{
            return String("Request: \n\t Source: \t latitude: \(sourceLat), longitude:  \(sourceLong) \n\t Destination: \t latitude:  \(destinationLat) , longitude: \(destinationLong) \n\t Departure Time: \(departureTime) \n\t Arrival Time: \(arrivalTime!) \n\t Has Arrival: \(hasArrivalTime) \n\t Type: \(type)")
        }
    }
    
    public  init() {
        self.sourceLat = Double()
        self.sourceLong = Double()
        self.destinationLat = Double()
        self.destinationLong = Double()
        self.departureTime = TimeInterval()
        self.arrivalTime = TimeInterval()
        self.hasArrivalTime = Bool()
        self.type = Int()
    }
    
    
    
    public init(sourceLat: Double,sourceLong: Double,destinationLat: Double,destinationLong: Double,departureTime: TimeInterval, arrivalTime: TimeInterval?, hasArrivalTime: Bool,type: Int){
        self.sourceLat = sourceLat
        self.sourceLong = sourceLong
        self.destinationLong = destinationLong
        self.destinationLat = destinationLat
        self.departureTime = departureTime
        self.hasArrivalTime = hasArrivalTime
        if hasArrivalTime {
            self.arrivalTime = arrivalTime
        }
        self.type = type
        
    }
    
    
    
    
    
    
}
