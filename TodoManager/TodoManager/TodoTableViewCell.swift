//
//  TodoTableViewCell.swift
//  TodoManager
//
//  Created by Marton Imre Farkas on 09/07/15.
//  Copyright © 2015 Farkas Marton Imre. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
