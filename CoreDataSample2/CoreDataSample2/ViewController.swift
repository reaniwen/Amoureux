//
//  ViewController.swift
//  CoreDataSample2
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
    
    var results: NSArray?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBAction func save(sender: UIButton) {
        
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        var cell = NSEntityDescription.insertNewObjectForEntityForName("Form", inManagedObjectContext:  context) as NSManagedObject
        cell.setValue(name.text, forKey: "name")
        cell.setValue(surname.text, forKey: "surname")
        
        context.save(nil)
        
        if(!context.save(nil)){
            println("Error!")
        }
        
        
        self.loadTable()
        self.table.reloadData()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTable() //start load
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
        var aux = results![indexPath.row] as NSManagedObject
        cell.textLabel.text = aux.valueForKey("name") as NSString
        cell.detailTextLabel?.text = aux.valueForKey("surname") as NSString
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results!.count
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String  {
        return "Contacts"
    }
    
    func loadTable(){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Form")
        request.returnsObjectsAsFaults = false
        results = context.executeFetchRequest(request, error: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



