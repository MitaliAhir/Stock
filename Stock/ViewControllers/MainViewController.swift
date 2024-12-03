//
//  MainViewController.swift
//  Stock
//
//  Created by Mitali Ahir on 2024-11-25.
//

import UIKit
import CoreData

//protocol MainViewControllerDelegate: AnyObject {
//    func didSelectStock(selectedState: StockState, selectedRank: StockRank, stock: TStock)
//}

class MainViewController: UIViewController {
    
    @IBOutlet weak var stockStateSegmentControl: UISegmentedControl!
    @IBOutlet weak var stockRateSegmentControl: UISegmentedControl!
    
    lazy var searchResultTableVC = storyboard?.instantiateViewController(withIdentifier: "SearchResultTVC") as! SearchResultTableViewController
    lazy var searchController = UISearchController(searchResultsController: searchResultTableVC)
    
    //var delegate: MainViewControllerDelegate?
    var tempStock : TStock?
    var didSelectStock: ((StockState, StockRank, TStock) -> Void)? // Closure to pass the data back to HomeViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchResultTableVC.delegate = self
    }// viewDidLoad() ends
  
   // Set the state and rank of the stock before unwinding to HomeScreen
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        // Capture the selected status from the segmented control
        let selectedState: StockState
        switch stockStateSegmentControl.selectedSegmentIndex {
            case 0:
            selectedState = .active
            case 1:
            selectedState = .watchlist
            default:
            selectedState = .active
            }
                
            // Capture the selected rank from the rank control
            let selectedRank: StockRank
            switch stockRateSegmentControl.selectedSegmentIndex {
            case 0:
                selectedRank = .cold
            case 1:
                selectedRank = .hot
            case 2:
                selectedRank = .veryHot
            default:
                selectedRank = .cold
            }
        
        guard let tempStock = tempStock else {
                print("Error: tempStock is nil.")
                return
            }
        
       //delegate?.didSelectStock(selectedState: selectedState, selectedRank: selectedRank, stock: tempStock)
        print("State: \(selectedState)")
        print("Rank: \(selectedRank)")
        // Pass the selected values and selected stock back to HomeViewController via closure
        if let didSelectStock = didSelectStock {
            didSelectStock(selectedState, selectedRank, tempStock)
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

