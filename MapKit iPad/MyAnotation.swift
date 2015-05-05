//
//  MyAnotation.swift
//  MapKit iPad
//
//  Created by Carlos Butron on 12/04/15.
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

class MyAnotation: NSObject, MKAnnotation {
    
    var title: NSString
    var subtitle: NSString
    var coordinate: CLLocationCoordinate2D
    func getTitle() -> NSString{
        return self.title
    }
    func getSubTitle() -> NSString {
        return self.subtitle
    }
    init(c:CLLocationCoordinate2D, t:NSString, st: NSString){
        coordinate = c
        title = t
        subtitle = st
    }
    
    
    
    
}
