//
//  InsertTableViewCell.swift
//  insert
//
//  Created by David Johnson on 1/18/17.
//  Copyright © 2017 David Johnson. All rights reserved.
//

import UIKit

class InsertTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "InsertCell"
    static let reuseHeaderIdentifier = "InsertHeaderCell"
    
    // MARK: -
    @IBOutlet weak var groupTitle: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    // MARK: - Initialization
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
