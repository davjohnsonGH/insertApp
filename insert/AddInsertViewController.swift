//
//  AddInsertViewController.swift
//  insert
//
//  Created by David Johnson on 1/18/17.
//  Copyright © 2017 David Johnson. All rights reserved.
//

import UIKit
import CoreData

class AddInsertViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var insertTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    var insertWithGroup: GroupedInsert?
    
    var insert: Insert?
    
    
    var managedObjectContext: NSManagedObjectContext?

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToolBar()
        if let insert = insert {
            
            insertTextField.text = insert.title
            contentTextView.text = insert.content
            
        }

        // Do any additional setup after loading the view.
    }
    
    func addToolBar ()->Void {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        
//        self.hidesBottomBarWhenPushed = false
//        
//        var toolBarItems: [UIBarButtonItem] = []
//        
//        let systemButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//        toolBarItems.append(systemButton1)
//        
//        let systemButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveButtonTapped))
//        toolBarItems.append(systemButton2)
//        
//        let systemButton3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//        toolBarItems.append(systemButton3)
//        
//        self.navigationController?.isToolbarHidden = false
//        self.setToolbarItems(toolBarItems, animated: true)
        //self.navigationController?.toolbarItems = toolbarItems;
        
    }
    
    func saveButtonTapped (sender: UIButton!) {
        
        guard let managedObjectContext = managedObjectContext else { return }
        
        if insert == nil {
            // Create Insert
            let newInsert = Insert(context: managedObjectContext)
            
            if insertWithGroup?.groupID != nil {
                
                newInsert.groupID = insertWithGroup?.groupID
                insertWithGroup?.addToInserts(newInsert)
                
            }
            
            // Configure Insert
            newInsert.createdAt = Date().timeIntervalSince1970
            
            // Set Insert
            insert = newInsert
        }
        
        if let insert = insert {
            // Configure Insert
            insert.title    = insertTextField.text
            insert.content  = contentTextView.text
        }
        // Pop View Controller
        _ = navigationController?.popViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
