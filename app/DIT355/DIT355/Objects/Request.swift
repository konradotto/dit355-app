//
//  Request.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-11.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Request : Codable {
    
    var deviceId        : String
    var requestId       : String
    var originLat       : Double
    var originLong      : Double
    var destinationLat  : Double
    var destinationLong : Double
    var departureTime   : Double
    var type            : String
    var purpose         : String
    var id              : String
    
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
        self.departureTime      = Double()
        self.type               = String()
        self.purpose            = String()
        self.id                 = String()
    }
    
    
    
    public init(deviceId: String,requestId: String,sourceLat: Double,sourceLong: Double,destinationLat: Double,destinationLong: Double,departureTime: Double,purpose: String,type: String){
        self.deviceId           = deviceId
        self.requestId          = requestId
        self.originLat          = sourceLat
        self.originLong         = sourceLong
        self.destinationLong    = destinationLong
        self.destinationLat     = destinationLat
        self.departureTime      = departureTime
        self.type               = type
        self.purpose            = purpose
        self.id                 = UUID().uuidString
    }
    
   public init(obj: JSON){
    
        self.deviceId           = obj["deviceId"].stringValue
        self.requestId          = obj["requestId"].stringValue
        self.originLat          = obj["origin"]["latitude"].doubleValue
        self.originLong         = obj["origin"]["longitude"].doubleValue
        self.destinationLong    = obj["destination"]["longitude"].doubleValue
        self.destinationLat     = obj["destination"]["latitude"].doubleValue
        self.departureTime      = obj["timeOfDeparture"].doubleValue
        self.type               = obj["transportationType"].stringValue
        self.purpose            = obj["purpose"].stringValue
        self.id                 = UUID().uuidString
    }
    
    
}
