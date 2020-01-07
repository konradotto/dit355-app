//
//  Cluster.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2020-01-07.
//  Copyright © 2020 DIT355-group. All rights reserved.
//

import Foundation
import MapKit

class Cluster: MKCircle{
    
    var type : String!

    class func circle(coord: CLLocationCoordinate2D, radius: CLLocationDistance, type: String)-> Cluster {
        let circle = Cluster(center: coord, radius: radius)
        circle.type = type
        return circle
    }
    
   
    
    
}
