//
//  CollectionTableViewCell.swift
//  BenSnake
//
//  Created by Ben on 19/12/2018.
//  Copyright © 2018 BehorDev. All rights reserved.
//

import UIKit

class LeaderbordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
