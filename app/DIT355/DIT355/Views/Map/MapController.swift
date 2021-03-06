//
//  MapController.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-11.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation


class MapController : NSObject {
    
    //MARK: - Class Variables
    static let shared = MapController()
    var mapView: MKMapView!
    let minCoord = CLLocation(latitude: 57.562184, longitude: 11.7018663)
    let maxCoord = CLLocation(latitude: 57.8580397, longitude: 12.2068462)
    lazy var mapRect = makeRect([minCoord.coordinate,maxCoord.coordinate])
    var state : Bool! {
        didSet{
            let _ = state ? (model.resetButton.isHidden = true) : (model.resetButton.isHidden = false)
        }
    }
    var annotations : [Annotation]
    let geoCoder = CLGeocoder()
    var placeMark: CLPlacemark! {
        didSet{
            self.addressString = self.parseAddress(placeMark)
        }
    }
    var addressString = String()
    var isStopsPlotted = false
    
    //MARK: - Managers & Composed objects
    var model: MapModel!
    var delegate: UIViewController!
    
    //MARK: - Constructor
    private override init(){
        annotations = [Annotation]()
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(plotAnnotations(notification:)), name: Notification.Name(rawValue:"plotAnnottions"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(filterAnnottions(notification:)), name: Notification.Name(rawValue:"filterType"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearAnnotations(notification:)), name: Notification.Name(rawValue:"clearAnnotations"), object: nil)
        
    }
    
    //MARK: - Class Functions
    /// Removes all annotations plotted on the map.
    func clearAnnotations(isSession: Bool){
        if isSession{
            NotificationCenter.default.post(name: Notification.Name("deselectRow"), object: nil)
        }
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.annotations.removeAll()
        self.mapView.removeOverlays(self.mapView.overlays)
        isStopsPlotted = false
        model.clearButton.isHidden = true
    }
    
    func removeClusters(type: String){
        
        let overlays = self.mapView.overlays
        var overlaysToRemove = [Cluster]()
        for overlay in overlays {
            if let o = overlay as? Cluster{
                if o.type == type{
                    overlaysToRemove.append(o)
                }
            }
        }
        DispatchQueue.main.async {
            self.mapView.removeOverlays(overlays)
        }
    }
    /// Setup the default view of the map.
    func initialView(animated: Bool){
        let ei = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        mapView.setVisibleMapRect(self.mapRect, edgePadding: ei, animated: animated)
    }
    /// Reverse geocode a passed annotation
    func getAddress(_ ann: Annotation){
        
        let clLoc = CLLocation(latitude: ann.coordinate.latitude, longitude: ann.coordinate.longitude)
        self.geoCoder.reverseGeocodeLocation(clLoc, completionHandler: { (placemark, error) in
            if let error = error as? CLError {
                print("GeoCoding error: ", error.localizedDescription)
                return
            } else if let placemark = placemark?.first {
                self.placeMark = placemark
            }
        })
    }
    /// Parse a returned placemark to a string; consisting of the street- name + number (if available).
    func parseAddress(_ selectedItem:CLPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        if !firstSpace.elementsEqual(""){
            return "\(selectedItem.thoroughfare!) \(selectedItem.subThoroughfare!)"
        }
        else {
            return "Address not available :("
        }
    }
    /// Add a passed annotation to the map on the main thread.
    func addAnnotations(_ ann: Annotation, isRequest: Bool){
        if isRequest{
            self.annotations.append(ann)
        }
        DispatchQueue.main.async {
            self.mapView.addAnnotation(ann)
        }
    }
    ///add an overlay to the map on the main thread
    func addClusterOverlay(center: CLLocationCoordinate2D, radius: Double, type: String){
        let cluster = Cluster.circle(coord: center, radius: radius, type: type)
        DispatchQueue.main.async {
            self.mapView.addOverlay(cluster)
        }
    }
    /// Navigate the visible map rectagle to the passed annotations
    func navigateTo(_ annotations: [Annotation]){
        let coords = annotations.map { (ann) -> CLLocationCoordinate2D in
            ann.coordinate
        }
        let rect = makeRect(coords)
        let ei = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        DispatchQueue.main.async {
            self.mapView.setVisibleMapRect(rect, edgePadding: ei, animated: true)
        }
    }
    /// Handle plotting the stops onto the map
    func plotStops(){
        if isStopsPlotted {
            let anns = self.mapView.annotations.filter { (ann) -> Bool in
                if let anno = ann as? Annotation{
                    return anno.id == "555"
                }
                return false
            }
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(anns)
            }
        }
        else {
            AnnotationManager.shared.readStopsCoordinates()
        }
        isStopsPlotted = !isStopsPlotted
    }
    
    //MARK: - Selector Methods
    @objc func filterAnnottions(notification: NSNotification){
        if let userInfo = notification.userInfo {
            if let filter = userInfo["filter"] as? String {
                guard !filter.contains("none")
                    else {
                        var annos = [Annotation]()
                        if filter.contains("bus"){
                            annos = self.annotations.filter({$0.type == "bus"})
                        }
                        else if filter.contains("tram"){
                            annos = self.annotations.filter({$0.type == "tram"})
                        }
                        else if filter.contains("ferry"){
                            annos = self.annotations.filter({$0.type == "ferry"})
                        }
                        DispatchQueue.main.async {
                            self.mapView.addAnnotations(annos)
                        }
                        return
                }
                let annsToRemove = self.annotations.filter {$0.type == filter}
                DispatchQueue.main.async {
                    self.mapView.removeAnnotations(annsToRemove)
                }
                
            }
        }
        
    }
    @objc func plotAnnotations(notification: NSNotification){
        
        if let userInfo = notification.userInfo {
            if let session = userInfo["session"] as? Session {
                self.annotations = session.annotations
                DispatchQueue.main.async {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addAnnotations(self.annotations)
                    self.mapView.showAnnotations(self.annotations, animated: true)
                }
            }
            
        }
        
    }
    
    @objc func clearAnnotations(notification: NSNotification){
        self.clearAnnotations(isSession: false)
    }
    
}
//MARK: - Class Extensions
extension MapController : MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        state = state != nil ? false : true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        else if let annotation = annotation as? Annotation {
            if annotation.id != "555"{
                if model.clearButton.isHidden {model.clearButton.isHidden = false}
            }
            let identifier = NSStringFromClass(Annotation.self)
            let view: MKMarkerAnnotationView =  MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            view.isEnabled = true
            view.animatesWhenAdded = true
            view.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = btn
            
            view.glyphImage = UIImage(named: annotation.type)
            
            if annotation.title == "Destination" {
                view.markerTintColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            } else if annotation.title == "Source"  {
                view.markerTintColor = #colorLiteral(red: 0.0009934299198, green: 0.4331022415, blue: 0.126284418, alpha: 1)
            }
            else {
                view.markerTintColor = #colorLiteral(red: 0.03201064659, green: 0.2225413255, blue: 0.8887412754, alpha: 1)
            }
            return view
            
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? Annotation {
            self.getAddress(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circelOverLay = overlay as? Cluster else {return MKOverlayRenderer()}
        let circleRenderer = MKCircleRenderer(circle: circelOverLay)
        if circelOverLay.type! == "arrival" {
            circleRenderer.fillColor = .orange
        }
        else {
            circleRenderer.fillColor = .blue
        }
        circleRenderer.strokeColor = .red
        circleRenderer.alpha = 0.2
        circleRenderer.lineWidth = 2
        return circleRenderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let _ = view.annotation as? Annotation {
            let title = "Address"
            let ac = UIAlertController(title: title, message: self.addressString, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.delegate.present(ac, animated: true)
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
