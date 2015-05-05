//
//  DocumentPhoto.swift
//  iCloud
//
//  Created by Carlos Butron on 07/12/14.
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

class DocumentPhoto: UIDocument {
    var image : UIImage!
    
    override func loadFromContents(contents: AnyObject, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        
        var data = NSData(bytes: contents.bytes, length: contents.length)
        self.image = UIImage(data: data)
        
        return true
    }
    
    override func contentsForType(typeName: String, error outError: NSErrorPointer) -> AnyObject? {
        
        return UIImageJPEGRepresentation(self.image, 1.0)
    }
    
//    override func loadFromContents(contents: AnyObject, ofType typeName:
//        String, error outError: NSErrorPointer) -> Bool {
//        if (contents.length > 0){
//        var data = NSData(bytes: contents.bytes, length:
//        contents.length)
//        self.image = UIImage(data: data)
//        }
//        return true
//    }
//    override func contentsForType(typeName: String, error outError:
//        NSErrorPointer) -> AnyObject? {
//        if (self.image == nil){
//        image = UIImage()
//        }
//        return UIImageJPEGRepresentation(self.image, 1.0)
//    }
    
    
    
    
    
}
