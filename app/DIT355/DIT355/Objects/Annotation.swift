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
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var type: String
    var discipline: String?
    var id: String = ""
    
    init(title: String, coordinate: CLLocationCoordinate2D,radius: Double?,type: String?, discipline: String?) {
        self.title = title
        self.coordinate = coordinate
        self.type = type ?? "undefined"
        self.discipline = discipline
        
        super.init()
    }
    
}
