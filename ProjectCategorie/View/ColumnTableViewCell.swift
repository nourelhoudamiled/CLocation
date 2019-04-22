//
//  ColumnTableViewCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 20/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ColumnTableViewCell: UITableViewCell {

    @IBOutlet var columnTextField: UITextField!
    @IBOutlet var columnLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
