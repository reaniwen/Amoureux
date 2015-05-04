//
//  NavigationViewController.swift
//  Amoureux
//
//  Created by 鸿烨 弓 on 15/4/17.
//  Copyright (c) 2015年 Firebase. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import AFNetworking

class NavigationViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    //add by Xiao
    let locationManager:CLLocationManager = CLLocationManager()
    @IBOutlet weak var location1: UILabel!
    @IBOutlet weak var temperature1: UILabel!
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var location2: UILabel!
    @IBOutlet weak var temperature2: UILabel!
    @IBOutlet weak var icon2: UIImageView!
    
    @IBOutlet var bgImageView : UIImageView!
    @IBOutlet var tview: UITableView!
    @IBOutlet var tableview: UITableView!
    
    
    @IBOutlet var bgImage: UIImageView!
    
    @IBOutlet var dimmerView  : UIView!
    
    @IBOutlet var dimmeruiview: UIView!
    var items : [NavigationModel]!
    var snapshot : UIView = UIView()
    var transitionOperator = TransitionOperator()
    var flongitude = ""
    var flatitude = ""
    var fuser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //add by Xiao
        //        var query = PFQuery(className:"follow")
        //        query.whereKey("user", equalTo:"\(PFUser.currentUser().username)")
        //
        let predicate = NSPredicate(format:"user = '\(PFUser.currentUser().username)' and userToFollow != '\(PFUser.currentUser().username)' ")
        var query = PFQuery(className:"follow", predicate:predicate)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                //println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.fuser = object.objectForKey("userToFollow") as String
                        //println(self.fuser)
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
        let predicate2 = NSPredicate(format:"username = 'hg@qq.com'")
        var query2 = PFQuery(className:"_User", predicate:predicate2)
        
        query2.findObjectsInBackgroundWithBlock {
            (objects2: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects2!.count) scores.")
                // Do something with the found objects
                if let objects2 = objects2 as? [PFObject] {
                    for object2 in objects2 {
                        self.flatitude = object2.objectForKey("latitude") as String
                        self.flongitude = object2.objectForKey("longitude") as String
                        
                        self.updateWeatherInfo2(self.flatitude, longitude: self.flongitude)
                        
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if ( ios8() ) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        
        
        tview.delegate = self
        tview.dataSource = self
        tview.separatorStyle = .None
        tview.backgroundColor = UIColor.clearColor()
        
        dimmerView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        bgImage.image = UIImage(named: "nav-bg")
        
        let item1 = NavigationModel(title: "Timeline", icon: "icon-home")
        let item2 = NavigationModel(title: "Chat", icon: "icon-chat")
        let item3 = NavigationModel(title: "Gallery", icon: "icon-image")
        let item4 = NavigationModel(title: "Settings", icon: "icon-setting")
        let item5 = NavigationModel(title: "Game", icon: "icon-game")
        let item6 = NavigationModel(title: "Calendar", icon: "icon-clock")
        let item7 = NavigationModel(title: "About", icon: "icon-info")
        
        items = [item1, item2, item3, item4, item5, item6, item7]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NavigationCell") as NavigationCell
        let item = items[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.countLabel.text = item.count
        cell.iconImageView.image = UIImage(named: item.icon)
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.snapshot.removeFromSuperview()
        
        if (indexPath.row == 1){
            performSegueWithIdentifier("newchatview", sender: self)
        }else if(indexPath.row == 2){
            performSegueWithIdentifier("photowall", sender: self)
        }else if(indexPath.row == 3) {
            performSegueWithIdentifier("settingnav", sender: self)
        }else if(indexPath.row == 4) {
            performSegueWithIdentifier("gamenav", sender: self)
        }else if(indexPath.row == 0) {
            performSegueWithIdentifier("timelineView", sender: self)
        }else if(indexPath.row == 5) {
            performSegueWithIdentifier("calendar", sender: self)
        }else if(indexPath.row == 6) {
            performSegueWithIdentifier("aboutus", sender: self)
        }else{
            performSegueWithIdentifier("othernav", sender: self)
        }
    }
    
    func finalizeTransitionWithSnapshot(snapshot: UIView){
        self.snapshot = snapshot
        view.addSubview(self.snapshot)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController as UIViewController
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
        toViewController.transitioningDelegate = self.transitionOperator
    }
    
    //add by Xiao
    func updateWeatherInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let manager = AFHTTPRequestOperationManager()
        
        let url = "http://api.openweathermap.org/data/2.5/forecast"
        
        let params = ["lat":latitude, "lon":longitude]
        
        println("|||||||||||||||||||||||||")
        println("\(params)")
        println("|||||||||||||||||||||||||")
        
        manager.GET(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                
                self.updateUISuccess(responseObject as NSDictionary!)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                
        })
    }
    
    func updateUISuccess(jsonResult: NSDictionary) {
        
        if let tempResult = ((jsonResult["list"]? as NSArray)[0]["main"] as NSDictionary)["temp"] as? Double {
            println("TempResult:", tempResult)
            // If we can get the temperature from JSON correctly, we assume the rest of JSON is correct.
            var temperature: Double
            var cntry: String
            cntry = ""
            if let city = (jsonResult["city"]? as? NSDictionary) {
                if let country = (city["country"] as? String) {
                    cntry = country
                    if (country == "US") {
                        // Convert temperature to Fahrenheit if user is within the US
                        temperature = round(((tempResult - 273.15) * 1.8) + 32)
                    }
                    else {
                        // Otherwise, convert temperature to Celsius
                        temperature = round(tempResult - 273.15)
                    }
                    
                    // FIXED: Is it a bug of Xcode 6? can not set the font size in IB.
                    //self.temperature.font = UIFont.boldSystemFontOfSize(60)
                    self.temperature1.text = "\(temperature)°"
                }
                
                if let name = (city["name"] as? String) {
                    self.location1.font = UIFont.boldSystemFontOfSize(15)
                    self.location1.text = name
                }
            }
            
            
            if let weatherArray = (jsonResult["list"]? as? NSArray) {
                for index in 0...4 {
                    println(index)
                    if let perTime = (weatherArray[index] as? NSDictionary) {
                        if let main = (perTime["main"]? as? NSDictionary) {
                            var temp = (main["temp"] as Double)
                            if (cntry == "US") {
                                // Convert temperature to Fahrenheit if user is within the US
                                temperature = round(((temp - 273.15) * 1.8) + 32)
                            }
                            else {
                                // Otherwise, convert temperature to Celsius
                                temperature = round(temp - 273.15)
                            }
                            
                            // FIXED: Is it a bug of Xcode 6? can not set the font size in IB.
                            //self.temperature.font = UIFont.boldSystemFontOfSize(60)
                        }
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        if let date = (perTime["dt"]? as? Double) {
                            let thisDate = NSDate(timeIntervalSince1970: date)
                            let forecastTime = dateFormatter.stringFromDate(thisDate)
                            
                        }
                        if let weather = (perTime["weather"]? as? NSArray) {
                            var condition = (weather[0] as NSDictionary)["id"] as Int
                            var icon = (weather[0] as NSDictionary)["icon"] as String
                            var nightTime = false
                            if icon.rangeOfString("n") != nil{
                                nightTime = true
                            }
                            self.updateWeatherIcon(condition, nightTime: nightTime, index: index)
                            if (index==4) {
                                return
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
    func updatePictures(index: Int, name: String) {
        if (index==0) {
            self.icon1.image = UIImage(named: name)
        }
    }
    
    func updateWeatherIcon(condition: Int, nightTime: Bool, index: Int) {
        // Thunderstorm
        
        var images = [self.icon1.image]
        
        if (condition < 300) {
            if nightTime {
                self.updatePictures(index, name: "tstorm1_night")
            } else {
                self.updatePictures(index, name: "tstorm1")
            }
        }
            // Drizzle
        else if (condition < 500) {
            self.updatePictures(index, name: "light_rain")
            
        }
            // Rain / Freezing rain / Shower rain
        else if (condition < 600) {
            self.updatePictures(index, name: "shower3")
        }
            // Snow
        else if (condition < 700) {
            self.updatePictures(index, name: "snow4")
        }
            // Fog / Mist / Haze / etc.
        else if (condition < 771) {
            if nightTime {
                self.updatePictures(index, name: "fog_night")
            } else {
                self.updatePictures(index, name: "fog")
            }
        }
            // Tornado / Squalls
        else if (condition < 800) {
            self.updatePictures(index, name: "tstorm3")
        }
            // Sky is clear
        else if (condition == 800) {
            if (nightTime){
                self.updatePictures(index, name: "sunny_night")
            }
            else {
                self.updatePictures(index, name: "sunny")
            }
        }
            // few / scattered / broken clouds
        else if (condition < 804) {
            if (nightTime){
                self.updatePictures(index, name: "cloudy2_night")
            }
            else{
                self.updatePictures(index, name: "cloudy2")
            }
        }
            // overcast clouds
        else if (condition == 804) {
            self.updatePictures(index, name: "overcast")
        }
            // Extreme
        else if ((condition >= 900 && condition < 903) || (condition > 904 && condition < 1000)) {
            self.updatePictures(index, name: "tstorm3")
        }
            // Cold
        else if (condition == 903) {
            self.updatePictures(index, name: "snow5")
        }
            // Hot
        else if (condition == 904) {
            self.updatePictures(index, name: "sunny")
        }
            // Weather condition is not available
        else {
            self.updatePictures(index, name: "dunno")
        }
    }
    
    
    //////////////////////////////////---------------------------
    
    func updateWeatherInfo2(latitude: String, longitude: String) {
        let manager = AFHTTPRequestOperationManager()
        
        let url = "http://api.openweathermap.org/data/2.5/forecast"

        let params = ["lat":latitude, "lon":longitude]
        
        println("-----------------------------")
        println("\(latitude)")
        println("\(longitude)")
        println("\(params)")
        println("-----------------------------")
        
        println("updateWeatherInfo2")
        
        manager.GET(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                println("JSON: " + responseObject.description!)
                self.updateUISuccess2(responseObject as NSDictionary!)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                
        })
    }
    
    func updateUISuccess2(jsonResult: NSDictionary) {
        
        println("updateUISuccess2")
        if let tempResult = ((jsonResult["list"]? as NSArray)[0]["main"] as NSDictionary)["temp"] as? Double {
            println("TempResult:", tempResult)
            // If we can get the temperature from JSON correctly, we assume the rest of JSON is correct.
            var temperature: Double
            var cntry: String
            cntry = ""
            if let city = (jsonResult["city"]? as? NSDictionary) {
                if let country = (city["country"] as? String) {
                    cntry = country
                    if (country == "US") {
                        // Convert temperature to Fahrenheit if user is within the US
                        temperature = round(((tempResult - 273.15) * 1.8) + 32)
                    }
                    else {
                        // Otherwise, convert temperature to Celsius
                        temperature = round(tempResult - 273.15)
                    }
                    
                    // FIXED: Is it a bug of Xcode 6? can not set the font size in IB.
                    //self.temperature.font = UIFont.boldSystemFontOfSize(60)
                    self.temperature2.text = "\(temperature)°"
                }
                
                if let name = (city["name"] as? String) {
                    self.location2.font = UIFont.boldSystemFontOfSize(15)
                    self.location2.text = name
                    println("\(name)")
                }
                
            }
            
            
            if let weatherArray = (jsonResult["list"]? as? NSArray) {
                for index in 0...4 {
                    println(index)
                    if let perTime = (weatherArray[index] as? NSDictionary) {
                        if let main = (perTime["main"]? as? NSDictionary) {
                            var temp = (main["temp"] as Double)
                            if (cntry == "US") {
                                // Convert temperature to Fahrenheit if user is within the US
                                temperature = round(((temp - 273.15) * 1.8) + 32)
                            }
                            else {
                                // Otherwise, convert temperature to Celsius
                                temperature = round(temp - 273.15)
                            }
                            
                            // FIXED: Is it a bug of Xcode 6? can not set the font size in IB.
                            //self.temperature.font = UIFont.boldSystemFontOfSize(60)
                        }
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        if let date = (perTime["dt"]? as? Double) {
                            let thisDate = NSDate(timeIntervalSince1970: date)
                            let forecastTime = dateFormatter.stringFromDate(thisDate)
                            
                        }
                        if let weather = (perTime["weather"]? as? NSArray) {
                            var condition = (weather[0] as NSDictionary)["id"] as Int
                            var icon = (weather[0] as NSDictionary)["icon"] as String
                            var nightTime = false
                            if icon.rangeOfString("n") != nil{
                                nightTime = true
                            }
                            self.updateWeatherIcon2(condition, nightTime: nightTime, index: index)
                            if (index==4) {
                                return
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
    func updatePictures2(index: Int, name: String) {
        if (index==0) {
            self.icon2.image = UIImage(named: name)
        }
    }
    
    func updateWeatherIcon2(condition: Int, nightTime: Bool, index: Int) {
        // Thunderstorm
        
        var images = [self.icon2.image]
        
        if (condition < 300) {
            if nightTime {
                self.updatePictures2(index, name: "tstorm1_night")
            } else {
                self.updatePictures2(index, name: "tstorm1")
            }
        }
            // Drizzle
        else if (condition < 500) {
            self.updatePictures2(index, name: "light_rain")
            
        }
            // Rain / Freezing rain / Shower rain
        else if (condition < 600) {
            self.updatePictures2(index, name: "shower3")
        }
            // Snow
        else if (condition < 700) {
            self.updatePictures2(index, name: "snow4")
        }
            // Fog / Mist / Haze / etc.
        else if (condition < 771) {
            if nightTime {
                self.updatePictures2(index, name: "fog_night")
            } else {
                self.updatePictures2(index, name: "fog")
            }
        }
            // Tornado / Squalls
        else if (condition < 800) {
            self.updatePictures2(index, name: "tstorm3")
        }
            // Sky is clear
        else if (condition == 800) {
            if (nightTime){
                self.updatePictures2(index, name: "sunny_night")
            }
            else {
                self.updatePictures2(index, name: "sunny")
            }
        }
            // few / scattered / broken clouds
        else if (condition < 804) {
            if (nightTime){
                self.updatePictures2(index, name: "cloudy2_night")
            }
            else{
                self.updatePictures2(index, name: "cloudy2")
            }
        }
            // overcast clouds
        else if (condition == 804) {
            self.updatePictures2(index, name: "overcast")
        }
            // Extreme
        else if ((condition >= 900 && condition < 903) || (condition > 904 && condition < 1000)) {
            self.updatePictures2(index, name: "tstorm3")
        }
            // Cold
        else if (condition == 903) {
            self.updatePictures2(index, name: "snow5")
        }
            // Hot
        else if (condition == 904) {
            self.updatePictures2(index, name: "sunny")
        }
            // Weather condition is not available
        else {
            self.updatePictures2(index, name: "dunno")
        }
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
            updateWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
            var query = PFQuery(className:"_User")
            query.getObjectInBackgroundWithId("\(PFUser.currentUser().objectId)") {
                (asd: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    println(error)
                } else if let asd = asd {
                    asd["longitude"] = "\(location.coordinate.longitude)"
                    asd["latitude"] = "\(location.coordinate.latitude)"
                    asd.save()
                }
            }
            
        }
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }
    
}

class NavigationModel {
    
    var title : String!
    var icon : String!
    var count : String?
    
    init(title: String, icon : String){
        self.title = title
        self.icon = icon
    }
    
    init(title: String, icon : String, count: String){
        self.title = title
        self.icon = icon
        self.count = count
    }
    
}
