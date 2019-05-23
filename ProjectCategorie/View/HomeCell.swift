//
//  HomeCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 21/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet var prixLabel: UILabel!
    @IBOutlet var nameProduit: UILabel!
    @IBOutlet var ratingCosmos: CosmosView!
    @IBOutlet var imageProduit: UIImageView!
    @IBOutlet var viewImage: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
