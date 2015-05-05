//
//  ViewController.swift
//  CoreDataSample1
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
import CoreData
        

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var results : NSArray?
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context : NSManagedObjectContext = appDel.managedObjectContext!
        
        
        //INSERT
        
//                var celda = NSEntityDescription.insertNewObjectForEntityForName("Cell", inManagedObjectContext:  context) as NSManagedObject
//                celda.setValue("Yoda Tux", forKey: "title")
//                celda.setValue("Science Fiction", forKey: "subtitle")
//                celda.setValue("yodaTux.png", forKey: "image")
//                if(!context.save(nil)){
//                    println("Error!")
//                }
        

            
            var request = NSFetchRequest (entityName: "Cell")
            request.returnsObjectsAsFaults = false
            
            results = context.executeFetchRequest(request, error: nil)
            
            if (results!.count>0){
                
                for res in results! {
                println(res)
                }
                
            }
            
            // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
                    super.didReceiveMemoryWarning()
                    // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                        
                        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
                        
                        var aux = results![indexPath.row] as NSManagedObject
                        
                        cell.textLabel.text = aux.valueForKey("title") as? String
                        cell.detailTextLabel?.text = aux.valueForKey("subtitle") as? String
                        cell.imageView.image = UIImage(named: aux.valueForKey("image") as String)
                        
                        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                            return results!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int)-> String  {
        return "TuxMania"
    }
    
    
}

