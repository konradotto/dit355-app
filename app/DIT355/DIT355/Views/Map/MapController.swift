//
//  MapController.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-11.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import MapKit

class MapController : NSObject {
    
    static let shared = MapController()

    var mapView: MKMapView!
    var model: MapModel!
    var delegate: MapViewController!
    
    let minCoord = CLLocation(latitude: 57.562184, longitude: 11.7018663)
    let maxCoord = CLLocation(latitude: 57.8580397, longitude: 12.2068462)
    lazy var mapRect = makeRect([minCoord.coordinate,maxCoord.coordinate])
    var state : Bool! {
        didSet{
            let _ = state ? (model.resetButton.isHidden = true) : (model.resetButton.isHidden = false)
        }
    }
    
    
    
    func initialView(animated: Bool){
        mapView.setVisibleMapRect(self.mapRect, animated: animated)
    }
        
    
}
extension MapController : MKMapViewDelegate {
    

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        state = state != nil ? false : true
    }
   
    
    
}
extension MapController {
    
    
    // From StackOverFlow: Returns the bounding map rect
    func makeRect(_ coordinates:[CLLocationCoordinate2D]) -> MKMapRect {
        
        var rect = MKMapRect()
        var coordinates = coordinates
        
        if !coordinates.isEmpty {
            let first = coordinates.removeFirst()
            var top = first.latitude
            var bottom = first.latitude
            var left = first.longitude
            var right = first.longitude
            coordinates.forEach { coordinate in
                top = max(top, coordinate.latitude)
                bottom = min(bottom, coordinate.latitude)
                left = min(left, coordinate.longitude)
                right = max(right, coordinate.longitude)
            }
            let topLeft = MKMapPoint(CLLocationCoordinate2D(latitude:top, longitude:left))
            let bottomRight = MKMapPoint(CLLocationCoordinate2D(latitude:bottom, longitude:right))
            rect = MKMapRect(x:topLeft.x, y:topLeft.y,
                             width:bottomRight.x - topLeft.x, height:bottomRight.y - topLeft.y)
        }
        return rect
    }
    
}
