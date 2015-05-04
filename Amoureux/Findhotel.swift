//
//  ViewController.swift
//  IOS8SwiftSearchMapTutorial
//
//  Created by Arthur Knopper on 20/04/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Findhotel: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    let locationManager:CLLocationManager = CLLocationManager()
    var initialLocation = CLLocation(latitude: 52.3740300, longitude: 4.8896900)
    let searchRadius: CLLocationDistance = 2000
    
    @IBAction func searchOnValueChanged(sender: AnyObject) {
        mapView.removeAnnotations(mapView.annotations)
        
        searchInMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if ( ios8() ) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        

    }
    
    func searchInMap() {
        // 1
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = segmentedControl.titleForSegmentAtIndex(segmentedControl.selectedSegmentIndex)
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        request.region = MKCoordinateRegion(center: initialLocation.coordinate, span: span)
        // 3
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler {
            (response: MKLocalSearchResponse!, error: NSError!) in
            
            for item in response.mapItems as [MKMapItem] {
                self.addPinToMapView(item.name, latitude: item.placemark.location.coordinate.latitude, longitude: item.placemark.location.coordinate.longitude)
            }
        }
    }
    
    func addPinToMapView(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MyAnnotation(coordinate: location, title: title)
        
        mapView.addAnnotation(annotation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    iOS 8 Utility
    */
    func ios8() -> Bool {
        
        if ( NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 ) {
            return false
        } else {
            return true
        }
    }
    
    //CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations[locations.count-1] as CLLocation
        
        if (location.horizontalAccuracy > 0) {
            self.locationManager.stopUpdatingLocation()
            println(location.coordinate)
            initialLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, searchRadius * 2.0, searchRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
            searchInMap()
        }
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }
    
    @IBAction func BackMenu(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        //Home.popViewControllerAnimated(true)
    }
    
}

