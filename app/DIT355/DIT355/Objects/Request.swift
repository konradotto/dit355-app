//
//  Request.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-11.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import CoreLocation

class Request: NSObject {
    
    var source          : CLLocation
    var destination     : CLLocation
    var departureTime   : TimeInterval
    var arrivalTime     : TimeInterval?
    var hasArrivalTime  : Bool
    var type            : String {
        get{return self.type}
        set {
            switch newValue {
            case "1":
                self.type = "Bus"
                break
            case "2":
                self.type = "Tram"
                break
            case "3":
                self.type = "Feiry"
                break
            default:
                self.type = "undefiened"
            }
        }
        
    }
    
    public override init() {
        self.source = CLLocation()
        self.destination = CLLocation()
        self.departureTime = TimeInterval()
        self.arrivalTime = TimeInterval()
        self.hasArrivalTime = Bool()
    }
    
    
    
    public init(source: CLLocation,destination: CLLocation,departureTime: TimeInterval, arrivalTime: TimeInterval?, hasArrivalTime: Bool,type: String){
        self.source = source
        self.destination = destination
        self.departureTime = departureTime
        self.hasArrivalTime = hasArrivalTime
        if hasArrivalTime {
            self.arrivalTime = arrivalTime
        }
        
    }
    
    
    
    
    
    
}
