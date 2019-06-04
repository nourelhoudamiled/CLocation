//
//  RegisterCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 02/06/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterCell: UITableViewCell {

    @IBOutlet var textfieldSky: SkyFloatingLabelTextField!
    @IBOutlet var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
