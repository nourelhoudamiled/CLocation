//
//  TitleCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 22/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var viewCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
