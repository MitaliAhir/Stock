//
//  HomeTableViewController.swift
//  Stock
//
//  Created by Mitali Ahir on 2024-11-27.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    
    var fetchedResultsController: NSFetchedResultsController<Stock>!
    // Create a context property (can be fetched from your AppDelegate or a container)
    var context: NSManagedObjectContext!
    @IBOutlet var savedStocksTableView: UITableView!
    
    var savedStocks: [Stock] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mainVC.delegate = self
        // Initialize Core Data context
        context = CoreDataStack.shared.persistentContainer.viewContext
        // Setup the fetchedResultsController
        setupFetchedResultsController()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath)
        let searchResult = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = searchResult.name
        cell.detailTextLabel?.text = "State: \(searchResult.state), Rank: \(searchResult.rank)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionData = fetchedResultsController.sections?[section].name else { return nil }
        if(sectionData == "0"){
            return "Active List"
        }
        else{
            return "Watch List"
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let stockToBeDeleted = fetchedResultsController.object(at: indexPath)
            context.delete(stockToBeDeleted)
            do  {
                try context.save()
            }catch{
                print("Error saving context: \(error.localizedDescription)")
            }
            
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
   

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    func setupFetchedResultsController(){
        // Initialize the fetched results controller
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "state", ascending: true)] // Sorting by state
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "state",
            cacheName: nil
        )
        fetchedResultsController.delegate = self

            do {
                try fetchedResultsController.performFetch()
            } catch {
                print("Failed to fetch search results: \(error)")
            }
    }
    // When a new search result is saved in Code Data model, these delegate methods will automatically notify the HomeViewController to update the table view.
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                     didChange anObject: Any,
                     at indexPath: IndexPath?,
                     for type: NSFetchedResultsChangeType,
                     newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange sectionInfo: any NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
     
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? MainViewController{
            sourceVC.didSelectStock = { [weak self] selectedState, selectedRank, tempStock in
                print("Unwinding back to HomeViewController with state: \(selectedState), rank: \(selectedRank), stock: \(tempStock.name)")
                CoreDataStack.shared.saveStockFromSearch(state: selectedState, rank: selectedRank, tempStock: tempStock)
            }
        }
    }
}
//extension HomeTableViewController: MainViewController1Delegate{
//    func didSelectStock(selectedState: StockState, selectedRank: StockRank, stock: TStock) {
//        print(stock.name)
//        CoreDataStack.shared.saveStockFromSearch(state: selectedState, rank: selectedRank, tempStock: stock)
//    }
//
//}
