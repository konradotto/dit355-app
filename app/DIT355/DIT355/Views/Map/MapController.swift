//
//  MapController.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-11.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import MapKit
import NotificationBannerSwift


class MapController : NSObject {
    
    static let shared = MapController()
    
    var mapView: MKMapView!
    var model: MapModel!
    var delegate: UIViewController!
    
    let minCoord = CLLocation(latitude: 57.562184, longitude: 11.7018663)
    let maxCoord = CLLocation(latitude: 57.8580397, longitude: 12.2068462)
    lazy var mapRect = makeRect([minCoord.coordinate,maxCoord.coordinate])
    var state : Bool! {
        didSet{
            let _ = state ? (model.resetButton.isHidden = true) : (model.resetButton.isHidden = false)
        }
    }
    
    lazy var sm = SessionManager.shared
    var annotations : [Annotation]
    
    private override init(){
        annotations = [Annotation]()
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(plotAnnotations(notification:)), name: Notification.Name(rawValue:"plotAnnottions"), object: nil)
        
    }
    
    @objc func plotAnnotations(notification: NSNotification){
        
        
        if let userInfo = notification.userInfo {
            if let session = userInfo["session"] as? Session {
                
                (0..<session.annotations.count).forEach { (i) in
                    self.annotations.append(session.annotations[i])
                }
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(self.annotations)
                }
            }
        }
        
    }
    
    func dismiss(){
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.annotations.removeAll()
    }
    
    func initialView(animated: Bool){
        let ei = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        mapView.setVisibleMapRect(self.mapRect, edgePadding: ei, animated: animated)
    }
    
    
}
extension MapController : MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        state = state != nil ? false : true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        else if let annotation = annotation as? Annotation {
            let identifier = NSStringFromClass(Annotation.self)
            let view: MKMarkerAnnotationView =  MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            view.animatesWhenAdded = false
            view.canShowCallout = false
            view.glyphImage = UIImage(named: annotation.type)
            
            if annotation.title == "Destination" {
                view.markerTintColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            } else {
                view.markerTintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            }
            return view
            
        } else {
            return nil
        }
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
