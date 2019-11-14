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
    
    var source          : CLLocation
    var destination     : CLLocation
    var departureTime   : TimeInterval
    var arrivalTime     : TimeInterval?
    var hasArrivalTime  : Bool
    var type            : TransportationType
    
    var description: String {
        get{
            return String("Request: \n\t Source: \(source.coordinate) \n\t Destination: \(destination.coordinate) \n\t Departure Time: \(departureTime) \n\t Arrival Time: \(arrivalTime!) \n\t Has Arrival: \(hasArrivalTime) \n\t Type: \(type)")
        }
    }
    
    public  init() {
        self.source = CLLocation()
        self.destination = CLLocation()
        self.departureTime = TimeInterval()
        self.arrivalTime = TimeInterval()
        self.hasArrivalTime = Bool()
        self.type = TransportationType.Undefined
    }
    
    
    
    public init(source: CLLocation,destination: CLLocation,departureTime: TimeInterval, arrivalTime: TimeInterval?, hasArrivalTime: Bool,type: Int){
        self.source = source
        self.destination = destination
        self.departureTime = departureTime
        self.hasArrivalTime = hasArrivalTime
        if hasArrivalTime {
            self.arrivalTime = arrivalTime
        }
        self.type = TransportationType(rawValue: type)!
        
    }
    
    
    
    
    
    
}
