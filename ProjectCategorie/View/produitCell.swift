//
//  produitCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 03/06/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class produitCell: UICollectionViewCell {

    @IBOutlet var prixLabel: UILabel!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var cosmosView: CosmosView!
    @IBOutlet var imageproduit: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
