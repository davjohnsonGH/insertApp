//
//  TableViewController.swift
//  insert
//
//  Created by David Johnson on 1/18/17.
//  Copyright © 2017 David Johnson. All rights reserved.
//

import UIKit
import CoreData

class GroupTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    // MARK: - Properties
    
    private let segueAddInsertViewController = "GroupToNewInsertSegue"
    private let segueEditInsertViewController = "SegueEditInsertViewController"
    private let segueGroupToInsertSegue = "GroupToInsertSegue"
    @IBOutlet var newWordField: UITextField?
    var insertWithGroup: GroupedInsert?
    let managedObjectContext = DatabaseController.getContext()
    
    // MARK: - Life Cycle Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var hasInititalGroup:Bool = false
        // set inital group
        let inserts = fetchedResultsController.fetchedObjects!
        
        for item in inserts {
            
            if (item.groupID == "*") {
                
                hasInititalGroup = true
            
            }
        
        }
        
        if hasInititalGroup == false {
            
            let newInsertGroup = GroupedInsert(context: managedObjectContext)
            
            // Configure InsertGroup
            newInsertGroup.createdAt = Date().timeIntervalSince1970
            newInsertGroup.title = "All inserts"
            newInsertGroup.groupID  = "*"
            newInsertGroup.preferredIndex = -1
            newInsertGroup.isGroup = true
            
            
            insertWithGroup = newInsertGroup
            
        
        }
        
        
//        updateView()
    }
    
    
    private func setupView() {
        initFetch()
        addToolBar()
//        updateView()
        setNavbar()
        setObservers()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    
    // MARK: - Table View Data Source
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//
//        if(section == 0) {
//            
//            let view = UIView() // The width will be the same as the cell, and the height should be set in tableView:heightForRowAtIndexPath:
//            let label = UILabel()
//            let button   = UIButton(type: UIButtonType.system)
//            
//            label.text="All Inserts"
//            
//            button.setTitle("See Inserts", for: .normal)
//            button.addTarget(self, action: #selector(allInsertsButtonPressed), for: .touchUpInside)
//            
//            view.addSubview(label)
//            view.addSubview(button)
//            view.backgroundColor = UIColor.lightGray
//            
//            label.translatesAutoresizingMaskIntoConstraints = false
//            button.translatesAutoresizingMaskIntoConstraints = false
//            
//            let views = ["label": label, "button": button, "view": view]
//            
//            let horizontallayoutContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[label]-60-[button]-10-|", options: .alignAllCenterY, metrics: nil, views: views)
//            view.addConstraints(horizontallayoutContraints)
//            
//            let verticalLayoutContraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
//            view.addConstraint(verticalLayoutContraint)
//            
//            return view
//        }
//        
//        return nil
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        
//        return 50
//    }
//    
    
    
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
        if indexPath.row == 0 {
            
            return false
            
        }
        
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Fetch Insert
            let insert = fetchedResultsController.object(at: indexPath)
            // hack to make up for cascade problem when using share app
            let fetchReq:NSFetchRequest<Insert> = Insert.fetchRequest()
            fetchReq.predicate = NSPredicate(format: "groupID == %@", insert.groupID!)
            
            
            do {
            
                let searchResults = try DatabaseController.getContext().fetch(fetchReq)
            
                for result in searchResults as [Insert] {
            
                    DatabaseController.getContext().delete(result)
                            
                    }
                        
                } catch {
                        
                    print("Error: \(error)")
                        
                }
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
            
            if insert.groupID == "*" {
                
                insert.preferredIndex = -1
                
            } else {
                
                insert.preferredIndex = Int16(i)
            
            }
            
        }
        
        DatabaseController.saveContext()
        tableView.reloadData()
        
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        if indexPath.row == 0 {
            
            return false
            
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "GroupToInsertSegue", sender: nil)
        
    }
    
    // MARK: - Helper Methods
    
    
    func allInsertsButtonPressed(button: UIButton) {
        
        self.performSegue(withIdentifier: "GroupToInsertSegue", sender: nil)

    }
    
//    private func updateView() {
//        var hasInserts = false
//        
//        if let inserts = self.fetchedResultsController.fetchedObjects {
//            hasInserts = inserts.count > 0
//        }
//        
//        tableView.isHidden = !hasInserts
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
        cell.groupTitle.text = insert.title
//        cell.contentLabel.text = insert.content
        
    }
    
    private func initializeFetchedResultsController(sortDescriptor: String) {
        
        let fetchRequest: NSFetchRequest<GroupedInsert> = GroupedInsert.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortDescriptor, ascending: true)]
        
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
        
        setAlert()
        
    }
    
    private func setAlert() {
        
        let title           = "add title for new group"
        let cancelText      = "cancel"
        let continueText    = "continue"
        
        let alert           = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: addTextField)
        let cancelAction    = UIAlertAction(title: cancelText, style: UIAlertActionStyle.cancel, handler: nil)
        let continueAction  = UIAlertAction(title: continueText, style: UIAlertActionStyle.default, handler: wordEntered)
        alert.addAction(cancelAction)
        alert.addAction(continueAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func wordEntered(alert: UIAlertAction!){
        
        let title = self.newWordField?.text
        
        let newInsertGroup = GroupedInsert(context: managedObjectContext)
        
        // Configure InsertGroup
        newInsertGroup.createdAt = Date().timeIntervalSince1970
        newInsertGroup.title = title
        newInsertGroup.groupID  = randomString(length: 10)
        newInsertGroup.isGroup = true
        
        insertWithGroup = newInsertGroup
        
//        updateView()
    
    }
    
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "title"
        self.newWordField = textField
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationViewController = segue.destination as? TableViewController else { return }
        
        // Configure View Controller
        destinationViewController.managedObjectContext = DatabaseController.getContext()
        
        if let indexPath = tableView.indexPathForSelectedRow, segue.identifier! == segueGroupToInsertSegue {
            // Configure View Controller
            destinationViewController.insertWithGroup = fetchedResultsController.object(at: indexPath)
        }
    }
    
    
}
