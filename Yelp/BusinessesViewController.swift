//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var businesses: [Business]!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredData: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        //Loaded from the "Thai" search term
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredData = businesses //assigns filtered data to be the same array as businesses
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
                
            }
        })
        
        
        navigationItem.titleView = searchBar

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let filteredData = filteredData
        {
            return filteredData.count
        }
        else
        {
            return 0
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = filteredData![indexPath.row]
        
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        //When there is no text, filteredData is the same as the original Data
        if searchText.isEmpty
        {
            filteredData = businesses
        }
        else
        {
            //The user has entered text into the search box
            //Use the filter method to iterate over all items in the data array
            //For each item, return true if the item should be included and false if the
            //item should NOT be included
            
            filteredData = businesses?.filter({(business: Business) -> Bool in
                
                if let item = business.name { //checks to see if the title is nil; if something is in it -> if_body else it will just return false
                    //if the title matches the searchText, return true to include it
                    if item.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                    {
                        return true
                    }
                    else
                    {
                        return false
                    }
                }
                return false
            })
        }
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
