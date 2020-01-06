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
    
    //MARK: - Class Variables
    var title           : String?
    var coordinate      : CLLocationCoordinate2D
    var type            : String
    var departureTime   : TimeInterval?
    var id              : String
    var subtitle        : String?
    
    //MARK: - Constructor
    init(title: String, coordinate: CLLocationCoordinate2D,purpose: String,type: String, depTime: TimeInterval?, id: String) {
        self.title          = title
        self.coordinate     = coordinate
        self.type           =  type
        self.departureTime  = depTime
        self.id             = id
        self.subtitle       = purpose
        super.init()
    }
    
}
