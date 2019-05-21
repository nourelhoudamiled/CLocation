//
//  DetailsProductCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 17/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class DetailsProductCell: UITableViewCell {

    @IBOutlet var uiswitch: UISwitch!
    @IBOutlet var telephoneLabel: UILabel!
    @IBOutlet var cityRegionLabel: UILabel!
    @IBOutlet var prixUniteLabel: UILabel!
    @IBOutlet var nameDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
