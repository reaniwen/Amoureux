//
//  ViewController.swift
//  MapKit iPad
//
//  Created by Carlos Butron on 02/12/14.
//  Copyright (c) 2014 Carlos Butron.
//
//  This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
//  License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later
//  version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
//  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//  You should have received a copy of the GNU General Public License along with this program. If not, see
//  http:/www.gnu.org/licenses/.
//

import UIKit
import MapKit




class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var myMap: MKMapView!
    
    var set = NSMutableArray()
    
    @IBAction func createAnotation(sender: AnyObject) {
        
        var a = MyAnotation(c: myMap.centerCoordinate, t: "Center", st: "The map center")
        
        mapView(myMap, viewForAnnotation: a)
        
        
        myMap.addAnnotation(a)
        
        
        set.addObject(a)
        
        
    }
    
    @IBAction func deleteAnotation(sender: AnyObject) {
        
        for (var i=0; i<myMap.annotations.count; i++) {
            myMap.removeAnnotations(set)
        }
        
        
    }
    
    @IBAction func coordinates(sender: AnyObject) {
        
        
        latitude.text = "\(myMap.centerCoordinate.latitude)"
        longitude.text = "\(myMap.centerCoordinate.longitude)"
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myMap.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation:
        MKAnnotation!) -> MKAnnotationView!{
            var pinView:MKPinAnnotationView = MKPinAnnotationView(annotation:
                annotation, reuseIdentifier: "Custom")
            //purple color to anotation
            //pinView.pinColor = MKPinAnnotationColor.Purple
            pinView.image = UIImage(named:"mypin.png")
            return pinView
    }
    
    
    
}



