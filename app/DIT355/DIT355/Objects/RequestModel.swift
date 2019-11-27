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
    
    var deviceId        : String
    var requestId       : String
    var originLat       : Double
    var originLong      : Double
    var destinationLat  : Double
    var destinationLong : Double
    var departureTime   : TimeInterval
    var type            : Int
    var purpose         : String
    
    var description: String {
        get{
            return String("Request: \n\t Device ID: \(deviceId) \n\t Request ID: \(requestId) \n\t Source: \t latitude: \(originLat), longitude:  \(originLong) \n\t Destination: \t latitude:  \(destinationLat) , longitude: \(destinationLong) \n\t Departure Time: \(departureTime) \n\t Purpose: \(purpose) \n\t Type: \(type)")
        }
    }
    
    public  init() {
        self.deviceId           = String()
        self.requestId          = String()
        self.originLat          = Double()
        self.originLong         = Double()
        self.destinationLat     = Double()
        self.destinationLong    = Double()
        self.departureTime      = TimeInterval()
        self.type               = Int()
        self.purpose            = String()
    }
    
    
    
    public init(deviceId: String,requestId: String,sourceLat: Double,sourceLong: Double,destinationLat: Double,destinationLong: Double,departureTime: TimeInterval,purpose: String,type: Int){
        self.deviceId           = deviceId
        self.requestId          = requestId
        self.originLat          = sourceLat
        self.originLong         = sourceLong
        self.destinationLong    = destinationLong
        self.destinationLat     = destinationLat
        self.departureTime      = departureTime
        self.type               = type
        self.purpose            = purpose
    }
    
    
}
