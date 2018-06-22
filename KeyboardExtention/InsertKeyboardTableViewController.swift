//
//  KeyboardTableViewController.swift
//  insert
//
//  Created by David Johnson on 2/18/17.
//  Copyright © 2017 David Johnson. All rights reserved.
// InsertKeyboardTableViewController

import UIKit
import CoreData


class InsertKeyboardTableViewController: UIInputViewController, UITableViewDelegate, UITableViewDataSource, KeyboardTableViewControllerDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var managedObjectContext = DatabaseController.getContext()
    var insertWithGroup: Insert?
    
    @IBAction func groupsButton(_ sender: Any) {
        
        self.fetchedResultsController = self.fetchedResultsControllerGroups as! NSFetchedResultsController<Insert>
        
        self.tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initFetch()
        initFetchGroups()
//        updateView()
        
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
        // #warning Incomplete implementation, return the number of rows
        guard let inserts = fetchedResultsController.fetchedObjects else { return 0 }
        return inserts.count
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierInsert", for: indexPath)
        
        let insert = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = insert.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let insert = fetchedResultsController.object(at: indexPath)
        
        // must check if selction is a group, if not then:
        
        
        // will add property to both models true/false is group or not
        
        if insert.isGroup == false {
            
            if insert.url != nil {
                
                (textDocumentProxy as UIKeyInput).insertText(insert.title! + ": " + insert.url!)
                
            } else {
                
                (textDocumentProxy as UIKeyInput).insertText(insert.title!)
            }
            
            
        
        } else {
            
            insertWithGroup = insert
            
            updateView()
            self.tableView.reloadData()
        
        
        }
        
        
        
        // if it is then repopulate table data with inserts from that group
        
//        delegate?.setText(textToSet: insert.title!)
        
    }
    
    @IBAction func nextKeyboard(_ sender: Any) {
        
//        delegate?.advanceToNext()
        self.advanceToNextInputMode()
        
    }
    func advanceToNext () {
        
        self.advanceToNextInputMode()
        
    }
    private func updateView() {
//        var hasInserts = false
        
//        if insertWithGroup?.groupID != "*" {
        
            initializeFetchedResultsController(predicate: (insertWithGroup?.groupID)!)
            
//        }         
//        if let inserts = self.fetchedResultsController.fetchedObjects {
//            hasInserts = inserts.count > 0
//        }
        
        //        tableView.isHidden = !hasInserts
        
    }
    
    private func initFetch() {
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
    }
    private func initFetchGroups() {
        
        do {
            try self.fetchedResultsControllerGroups.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
    }
    
    
    private func initializeFetchedResultsController(predicate: String) {
        
        let fetchRequest: NSFetchRequest<Insert> = Insert.fetchRequest()
        
        if predicate != "*" {
            
            fetchRequest.predicate = NSPredicate(format: "groupID == %@", predicate)
        
        }
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "preferredIndex", ascending: true), NSSortDescriptor(key: "createdAt", ascending: false)]
        
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DatabaseController.getContext(),
            sectionNameKeyPath: nil,
            cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
//        func setText (textToSet: String) {
//    
//            (textDocumentProxy as UIKeyInput).insertText(textToSet)
//    
//        }
//    
//    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        setText()
//        
//        
//    }
    
    
    fileprivate lazy var fetchedResultsControllerGroups: NSFetchedResultsController<GroupedInsert> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<GroupedInsert> = GroupedInsert.fetchRequest()
        
        // Configure Fetch Request
        //        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "preferredIndex", ascending: true), NSSortDescriptor(key: "createdAt", ascending: false)]
        
        // Create Fetched Results Controller
        let fetchedResultsControllerGroups = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DatabaseController.getContext(),
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsControllerGroups.delegate = self
        
        return fetchedResultsControllerGroups
    }()
    
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Insert> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Insert> = Insert.fetchRequest()
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        let controller = segue.destination as! InsertKeyboardTableViewController
                guard let destinationViewController = segue.destination as? KeyboardTableViewController else { return }
        
                destinationViewController.delegate = self
        // Configure View Controller
        //        destinationViewController.managedObjectContext = DatabaseController.getContext()
        //
        //        if let indexPath = tableView.indexPathForSelectedRow, segue.identifier! == segueGroupToInsertSegue {
        //            // Configure View Controller
        //            destinationViewController.insertWithGroup = fetchedResultsController.object(at: indexPath)
        //        }
    }
    
}
