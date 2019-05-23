//
//  DetailOfUserCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 23/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class DetailOfUserCell: UITableViewCell {

    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var nameUserLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
