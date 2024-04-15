//
//  ViewController.swift
//  Weather App
//
//  Created by Hamit Sehjal on 2024-04-14.
//

import UIKit

//struct City{
//    let name:String
//    let latitude:Double
//    let longitude:Double
//}


class AddCityViewController: UIViewController,UITableViewDataSource,UISearchResultsUpdating{
    
    
    var listOfCities:[String]=[]
    
   
    @IBOutlet weak var tableView: UITableView!
    var searchController:UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource=self
        
        // Initializing with searchResultsController set to 'nil' means we will use current view controller to display the search results
        searchController=UISearchController(searchResultsController: nil)
        
        // setting the current view controller as object responsible for updating the search results controller
        searchController.searchResultsUpdater=self
        searchController.searchBar.sizeToFit()

//        navigationItem.searchController=searchController
        tableView.tableHeaderView=searchController.searchBar
        
        // set this controller as presenting view controller for the search interface
        definesPresentationContext=true
    }
    
    // MARK - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "SearchCityCell")!
        cell.textLabel?.text=listOfCities[indexPath.row]
        return cell
    }
    
    // MARK - Search Controller
    func updateSearchResults(for searchController: UISearchController) {
        if let cityName=searchController.searchBar.text{
            let searchParams=["q":cityName]
            // make request to the GeoBytesAPI to fetch list of cities
            ServiceAPI.fetchCityList(parameters: searchParams, completion: {
                (citiesResult) in
                
                switch citiesResult{
                case let .success(cityList):
                    print("Successfully fetched \(cityList.count) cities")
                                        self.listOfCities=cityList
                case let .failure(error):
                    print("Error Fetching cities: \(error)")
                    
                }
            })
            
        }
        tableView.reloadData()
    }
}

