//
//  MenuTableViewCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 04/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {


    @IBOutlet var imageBar: UIImageView!
    @IBOutlet var labelBar: UILabel!
  
    @IBOutlet var imageMenuBar: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
