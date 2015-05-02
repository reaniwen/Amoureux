//
//  GamesViewController.swift
//  Amoureux
//
//  Created by 鸿烨 弓 on 15/5/1.
//  Copyright (c) 2015年 Firebase. All rights reserved.
//

import UIKit

class GamesViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    var candies = [Candy]()
    var filteredCandies = [Candy]()
    

    override func viewDidLoad() {
        //Sample Data for candyArray
        self.candies = [Candy(category:"MultiGame", name:"Tic Tac Toe"),
            Candy(category:"SingleGame", name:"Flappy Bird")]
        
        // Reload the table
        self.tableView.reloadData()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"whiteleft.png"),landscapeImagePhone:UIImage(named: "whiteleft.png"), style:.Bordered, target: self, action:"back:")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func back(_: UIBarButtonItem!){
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredCandies.count
        } else {
            return self.candies.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        var candy : Candy
        // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            candy = filteredCandies[indexPath.row]
        } else {
            candy = candies[indexPath.row]
        }
        
        // Configure the cell
        cell.textLabel!.text = candy.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredCandies = self.candies.filter({( candy : Candy) -> Bool in
            var categoryMatch = (scope == "All") || (candy.category == scope)
            var stringMatch = candy.name.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!,
        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
            let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
            self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
            return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0){
            self.performSegueWithIdentifier("candyDetail", sender: tableView)
        }else {
            self.performSegueWithIdentifier("flappybird", sender: tableView)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "candyDetail" {
            let candyDetailViewController = segue.destinationViewController as UIViewController
            if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                let destinationTitle = self.filteredCandies[indexPath.row].name
                candyDetailViewController.title = destinationTitle
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = self.candies[indexPath.row].name
                candyDetailViewController.title = destinationTitle
            }
        }else if segue.identifier == "flappybird" {
            let candyDetailViewController = segue.destinationViewController as UIViewController
            if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                let destinationTitle = self.filteredCandies[indexPath.row].name
                candyDetailViewController.title = destinationTitle
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = self.candies[indexPath.row].name
                candyDetailViewController.title = destinationTitle
            }
        }
        
    }
}
