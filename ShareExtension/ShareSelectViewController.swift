//
//  ShareSelectViewController.swift
//  insert
//
//  Created by David Johnson on 1/22/17.
//  Copyright © 2017 David Johnson. All rights reserved.
//

import UIKit

protocol ShareSelectViewControllerDelegate: class {
    
    func selected(deck: GroupedInsert)
    
}


extension ShareSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.selected(deck: inserts[indexPath.row])
    }
}


extension ShareSelectViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return inserts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: Identifiers.DeckCell)
        
        cell.textLabel?.text = (inserts[indexPath.row].title)!
        cell.backgroundColor = .clear
        return cell
    }
}

private extension ShareSelectViewController {
    struct Identifiers {
        static let DeckCell = "deckCell"
    }
}

class ShareSelectViewController: UIViewController {
    
    weak var delegate: ShareSelectViewControllerDelegate?
    
    var inserts = [GroupedInsert]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        title = "Select Deck"
        view.addSubview(tableView)
        
        
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
