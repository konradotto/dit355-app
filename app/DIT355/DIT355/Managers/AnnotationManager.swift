//
//  ConversionManager.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-27.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

class AnnotationManager {
    
    static let shared = AnnotationManager()
    var annotations = [Annotation]()
    
    private init(){}
    
    func toStruct(_ str: String){
        
        let jsonData  = JSON(parseJSON: str)
        let jsonObjet = jsonData["travelRequest"]
        self.toAnnotations(RequestModel(obj: jsonObjet))
    }
    
    
    func toAnnotations(_ rm : RequestModel){
        let sourceCoord = CLLocationCoordinate2D(latitude: rm.originLat, longitude: rm.originLong)
        let targetCoord = CLLocationCoordinate2D(latitude: rm.destinationLat, longitude: rm.destinationLong)

        //need to convert the timeinterval tho
        annotations.append(Annotation(title: "Source",
                                      coordinate: sourceCoord,
                                      type: rm.type,
                                      purpose: rm.purpose,
                                      depTime: rm.departureTime,
                                      id: rm.id))
        annotations.append(Annotation(title: "destination",
                                      coordinate: targetCoord,
                                      type: rm.type,
                                      purpose: rm.purpose,
                                      depTime: rm.departureTime,
                                      id: rm.id))
        
        
        
    }
 
    
    
    
}
