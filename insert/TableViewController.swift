//
//  TableViewController.swift
//  insert
//
//  Created by David Johnson on 1/18/17.
//  Copyright © 2017 David Johnson. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    // MARK: - Properties
    
    private let segueAddInsertViewController = "AddInsertSegue"
    private let segueEditInsertViewController = "SegueEditInsertViewController"
    var insertWithGroup: GroupedInsert?
    var managedObjectContext: NSManagedObjectContext?
    
    // MARK: - Life Cycle Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //updateView()
    }
    
    
    private func setupView() {
        initFetch()
        addToolBar()
        updateView()
        setNavbar()
        setObservers()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let inserts = fetchedResultsController.fetchedObjects else { return 0 }
        return inserts.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InsertTableViewCell.reuseIdentifier, for: indexPath) as? InsertTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        configure(cell, at: indexPath)
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Fetch Insert
            let insert = fetchedResultsController.object(at: indexPath)
            // Delete Insert
            insert.managedObjectContext?.delete(insert)

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        var inserts = self.fetchedResultsController.fetchedObjects!
        //        self.fetchedResultsController.delegate = nil
        
        let insert = inserts[fromIndexPath.row]
        
        inserts.remove(at: fromIndexPath.row)
        inserts.insert(insert, at: to.row)
        
        for (i, insert) in inserts.enumerated() {
            insert.preferredIndex = Int16(i)
        }
        DatabaseController.saveContext()
        tableView.reloadData()

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    // MARK: - Helper Methods
    
    private func updateView() {
//        var hasInserts = false
        
        if insertWithGroup?.groupID != "*" {
            
            initializeFetchedResultsController(predicate: (insertWithGroup?.groupID)!)
            
        }
        
//        if let inserts = self.fetchedResultsController.fetchedObjects {
//            hasInserts = inserts.count > 0
//        }
//        
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
    
    private func setNavbar() {
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    private func setObservers() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidEnterBackground(_:)),
            name: Notification.Name.UIApplicationDidEnterBackground,
            object: nil)
        
    }
    
    @objc func applicationDidEnterBackground(_ notification: Notification) {
        
        do {
            try DatabaseController.getContext().save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
        
    }
    
    private func configure(_ cell: InsertTableViewCell, at indexPath: IndexPath) {
        // Fetch Item
        let insert = fetchedResultsController.object(at: indexPath)
        // Configure Cell
        cell.titleLabel.text = insert.title
        cell.contentLabel.text = insert.content
        
    }
    
//    func initializeFetchedResultsController(sortDescriptor: String) {
//        
//        let fetchRequest: NSFetchRequest<Insert> = Insert.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortDescriptor, ascending: true)]
//        
//        self.fetchedResultsController = NSFetchedResultsController(
//            fetchRequest: fetchRequest,
//            managedObjectContext: DatabaseController.getContext(),
//            sectionNameKeyPath: nil,
//            cacheName: nil)
//        self.fetchedResultsController.delegate = self
//        
//        do {
//            try self.fetchedResultsController.performFetch()
//        } catch {
//            fatalError("Failed to initialize FetchedResultsController: \(error)")
//        }
//    }
//    
   private func initializeFetchedResultsController(predicate: String) {
        
        let fetchRequest: NSFetchRequest<Insert> = Insert.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "groupID == %@", predicate)
        
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
    
    // Syncing Core Data and Table Data
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? InsertTableViewCell {
                configure(cell, at: indexPath)
            }
            break;
        default:
            print("...")
        }
    }
    
    // MARK: - Data Management
    
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Interaction and Experiance
    
    // TODO: Change to toolbar and get correct icons / buttons
    func addToolBar ()->Void {
        
        self.hidesBottomBarWhenPushed = false
        
        var toolBarItems: [UIBarButtonItem] = []
        
        let systemButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBarItems.append(systemButton1)
        
        let systemButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addButtonTapped))
        toolBarItems.append(systemButton2)
        
        let systemButton3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBarItems.append(systemButton3)
        
        self.navigationController?.isToolbarHidden = false
        self.setToolbarItems(toolBarItems, animated: true)
        //self.navigationController?.toolbarItems = toolbarItems;
        
    }
    
    @objc func addButtonTapped (sender: UIButton!) {
        self.performSegue(withIdentifier: "AddInsertSegue", sender: nil)
        
    }
    
     // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationViewController = segue.destination as? AddInsertViewController else { return }
        
        // Configure View Controller
        destinationViewController.managedObjectContext = DatabaseController.getContext()
        
        if let indexPath = tableView.indexPathForSelectedRow, segue.identifier! == segueEditInsertViewController {
            // Configure View Controller
            destinationViewController.insert = fetchedResultsController.object(at: indexPath)
            
        } else {
            
            destinationViewController.insertWithGroup = insertWithGroup
        }
    }
    

}
