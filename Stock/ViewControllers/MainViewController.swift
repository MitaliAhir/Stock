//
//  MainViewController.swift
//  Stock
//
//  Created by Mitali Ahir on 2024-11-25.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak var stockStateSegmentControl: UISegmentedControl!
    
    lazy var searchResultTableVC = storyboard?.instantiateViewController(withIdentifier: "SearchResultTVC") as! SearchResultTableViewController
    lazy var searchController = UISearchController(searchResultsController: searchResultTableVC)
    
    var selectedState = 0
    var selectedRank = 0
    var tempStock : TStock?
    // Create a context property (can be fetched from your AppDelegate or a container)
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchResultTableVC.delegate = self
        
    }// viewDidLoad() ends
  
    @IBAction func stateSegmentValueChanged(_ sender: UISegmentedControl) {
        selectedState = sender.selectedSegmentIndex
        
    }
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        selectedState = stockStateSegmentControl.selectedSegmentIndex
        if let tempStock = tempStock {
            CoreDataStack.shared.saveStockFromSearch(tempStock: tempStock, rank: selectedRank, state: selectedState)
        }
    }
    
    
}
extension MainViewController: UISearchResultsUpdating {
    //notify us everytime there is an update in search text
    func updateSearchResults(for searchController: UISearchController) {
        guard let data = searchController.searchBar.text else { return }
        let urlStr = "https://ms-finance.p.rapidapi.com/market/v2/auto-complete?q=\(data)"
        APIClient.shared.fetchStocks(forURL: urlStr){ data in
//              printing data for debugging
//            let stringData = String(data: data, encoding: .utf8)
//            print(stringData ?? "No Data")
            let decoder = JSONDecoder();
            if let stock = try? decoder.decode(ResultValues.self, from: data) {
                self.searchResultTableVC.stockFromSearch = stock.results
                }
            }
    }
        
}
extension MainViewController :SearchResultTableViewControllerDelegate{
    func didSelectStock(_ stock: TStock) {
        searchController.isActive = false
        tempStock = stock
        title = stock.name
    }

}

