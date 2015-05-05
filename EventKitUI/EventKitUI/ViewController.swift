//
//  ViewController.swift
//  EventKitUI
//
//  Created by Carlos Butron on 02/12/14.
//  Copyright (c) 2015 Carlos Butron. All rights reserved.
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
import EventKitUI

class ViewController: UIViewController, EKEventEditViewDelegate {
    
    var store = EKEventStore()
    
    @IBAction func calendar(sender: UIButton) {
        
        
        store.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted, error) -> Void in
            if (granted) {
                println("Access granted")
                
                
                var controller = EKEventEditViewController()
                controller.eventStore = self.store
                controller.editViewDelegate = self
                self.presentViewController(controller, animated: true, completion: nil)
            }else{
                println("Access denied")
            }
        })
        
    }
    
    
    @IBAction func deleteEvents(sender: UIButton) {
        //get calendar
        var calendar = NSCalendar.currentCalendar()
        //get start and end date
        let aDayBeforeComponents = NSDateComponents()
        aDayBeforeComponents.day = -1
        let aDayBefore : NSDate = calendar.dateByAddingComponents(aDayBeforeComponents, toDate: NSDate(), options: NSCalendarOptions(0))!
        let yearAfterComponents = NSDateComponents()
        yearAfterComponents.year = 1
        let yearAfter : NSDate = calendar.dateByAddingComponents(yearAfterComponents, toDate: NSDate(), options: NSCalendarOptions(0))!
        //create predicate
        let predicate : NSPredicate = self.store.predicateForEventsWithStartDate(aDayBefore, endDate: yearAfter, calendars: nil)
        //get related events
        let events : NSArray = self.store.eventsMatchingPredicate(predicate)
        
        
        
        
        ////loop all events in events and delete it
        for i in events{
            self.store.removeEvent(i as EKEvent, span: EKSpanThisEvent, commit: true, error: nil)
            //println(i)
        }
        
    }
    
    
    @IBAction func setAlarm(sender: UIButton) {
        
        //get calendar
        var calendar = NSCalendar.currentCalendar()
        //get start and end date
        let aDayBeforeComponents = NSDateComponents()
        aDayBeforeComponents.day = -1
        let aDayBefore : NSDate = calendar.dateByAddingComponents(aDayBeforeComponents, toDate: NSDate(), options: NSCalendarOptions(0))!
        let yearAfterComponents = NSDateComponents()
        yearAfterComponents.year = 1
        let yearAfter : NSDate = calendar.dateByAddingComponents(yearAfterComponents, toDate: NSDate(), options: NSCalendarOptions(0))!
        //create predicate
        let predicate : NSPredicate = self.store.predicateForEventsWithStartDate(aDayBefore, endDate: yearAfter, calendars: nil)
        //get related events
        let events : NSArray = self.store.eventsMatchingPredicate(predicate)
        
        
        //loop all events in events and add alarm to all
        for i in events{
            let eventWithAlarm = i as EKEvent
            let alarm = EKAlarm(relativeOffset: -2.0)
            eventWithAlarm.addAlarm(alarm)
            self.store.saveEvent(eventWithAlarm, span: EKSpanThisEvent, error: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    override func viewDidAppear(animated: Bool) {
    //
    //    }
    
    func eventEditViewController(controller: EKEventEditViewController!, didCompleteWithAction action: EKEventEditViewAction) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

