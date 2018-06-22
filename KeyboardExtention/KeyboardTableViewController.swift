//
//  KeyboardTableViewController.swift
//  insert
//
//  Created by David Johnson on 2/18/17.
//  Copyright © 2017 David Johnson. All rights reserved.
//

import UIKit
import CoreData

protocol KeyboardTableViewControllerDelegate: class {
    
//    func setText (textToSet: String)
    func advanceToNext ()
    
}


class KeyboardTableViewController: UIInputViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    weak var delegate: KeyboardTableViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    private let segueGroupToInsertSegue = "GroupToInsertSegue"
//    var managedObjectContext = DatabaseController.getContext()
//    var insertWithGroup: GroupedInsert?
//    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFetch()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let inserts = fetchedResultsController.fetchedObjects else { return 0 }
        
        return inserts.count
    }

    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let insert = fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = insert.title

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let insert = fetchedResultsController.object(at: indexPath)
        
        // call segue to InsertKeyboardView and send GroupIdDelegate, sends user back to insert view
        performSegue(withIdentifier: "InsertKeyboardTableViewSegue", sender: nil)
        
        
        
    }
    
//    func setText (textToSet: String) {
//                
//        (textDocumentProxy as UIKeyInput).insertText(textToSet)
//    
//    }
    
    private func initFetch() {
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
    }
    
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<GroupedInsert> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<GroupedInsert> = GroupedInsert.fetchRequest()
        
        // Configure Fetch Request
        //        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "preferredIndex", ascending: true), NSSortDescriptor(key: "createdAt", ascending: false)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DatabaseController.getContext(),
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
 
    @IBAction func nextKeyboard(_ sender: Any) {
        
//        self.advanceToNextInputMode()
//        advanceToNext()
        delegate?.advanceToNext()
    }
    
//    func advanceToNext () {
//        
//        self.advanceToNextInputMode()
//        
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        let controller = segue.destination as! InsertKeyboardTableViewController
////        guard let destinationViewController = segue.destination as? InsertKeyboardTableViewController else { return }
//        
////        destinationViewController.delegate = self
//        // Configure View Controller
////        destinationViewController.managedObjectContext = DatabaseController.getContext()
////        
////        if let indexPath = tableView.indexPathForSelectedRow, segue.identifier! == segueGroupToInsertSegue {
////            // Configure View Controller
////            destinationViewController.insertWithGroup = fetchedResultsController.object(at: indexPath)
////        }
//    }

}
