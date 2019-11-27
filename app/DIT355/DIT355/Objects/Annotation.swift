//
//  Annotation.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-14.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
    
    var title           : String?
    var coordinate      : CLLocationCoordinate2D
    var type            : String
    var departureTime   : TimeInterval?
    var purpose         : String
    var id              : String
    
    init(title: String, coordinate: CLLocationCoordinate2D, type: String?,purpose: String, depTime: TimeInterval?, id: String) {
        self.title          = title
        self.coordinate     = coordinate
        self.type           = type ?? "undefined"
        self.departureTime  = depTime
        self.purpose        = purpose
        self.id             = id
        super.init()
    }
    
}
