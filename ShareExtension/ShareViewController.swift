//
//  ShareViewController.swift
//  InsertShare
//
//  Created by David Johnson on 1/22/17.
//  Copyright © 2017 David Johnson. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import CoreData

private var selectedDeck: GroupedInsert?

extension ShareViewController: ShareSelectViewControllerDelegate, NSFetchedResultsControllerDelegate {
    func selected(deck: GroupedInsert) {
        selectedDeck = deck
        reloadConfigurationItems()
        popConfigurationViewController()
    }
}

class ShareViewController: SLComposeServiceViewController {
    
    
    private var urlString: String?
    private var inserts = [GroupedInsert]()
    var managedObjectContext =  DatabaseController.getContext()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFetch()
        inserts = self.fetchedResultsController.fetchedObjects!
        selectedDeck = inserts.first
        
        
        //hackernoon.com/how-to-build-an-ios-share-extension-in-swift-4a2019935b2e#.7809ieu9p
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        let propertyList = String(kUTTypePropertyList)
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
                guard let dictionary = item as? NSDictionary else { return }
                OperationQueue.main.addOperation {
                    if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary, let urlString = results["URL"] as? String {
                        
                        
                        self.urlString = urlString
                    }
                }
            })
        } else {
            
            print("error", Error.self)
            
        }
        
    }
    
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func didSelectPost() {
        
        let newGroupedInsert = Insert(context: managedObjectContext)
        
        newGroupedInsert.createdAt = Date().timeIntervalSince1970
        newGroupedInsert.title    = contentText
        newGroupedInsert.groupID  = selectedDeck?.groupID
        
        DatabaseController.saveContext()
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
        
        // populate with core data groups only
        
        let deck = SLComposeSheetConfigurationItem()
        deck?.title = "Selected Group"
        deck?.value = selectedDeck?.title
        deck?.tapHandler = {
            
            let vc = ShareSelectViewController()
            
            vc.inserts = self.inserts
            vc.delegate = self
            
            self.pushConfigurationViewController(vc)
            
        }
        return [deck!]
        
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
    
}
