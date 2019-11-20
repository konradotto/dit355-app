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
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let radius: Double
    let type: String
    let discipline: String?
    var id: String = ""
    
    init(title: String, coordinate: CLLocationCoordinate2D,radius: Double?,type: String?, discipline: String?) {
        self.title = title
        self.coordinate = coordinate
        self.radius = radius ?? 0
        self.type = type ?? "Basic"
        self.discipline = discipline
        
        super.init()
    }
    
}
