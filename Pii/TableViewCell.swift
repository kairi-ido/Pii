//
//  TableViewCell.swift
//  Pii
//
//  Created by 井戸海里 on 2020/10/04.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var hosuLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
