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
    
    //MARK: - Structure Variables
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
    
    //MARK: - Description:
    var description: String {
        get{
            return String("Request: \n\t Device ID: \(deviceId) \n\t Request ID: \(requestId) \n\t Source: \t latitude: \(originLat), longitude:  \(originLong) \n\t Destination: \t latitude:  \(destinationLat) , longitude: \(destinationLong) \n\t Departure Time: \(departureTime) \n\t Purpose: \(purpose)\n\t Trasportation Type: \(type)")
        }
    }
    
    //MARK: - Constructor
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
