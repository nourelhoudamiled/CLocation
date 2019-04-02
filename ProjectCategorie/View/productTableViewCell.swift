//
//  productTableViewCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 29/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class productTableViewCell: UITableViewCell {

    @IBOutlet var nameProduct: UILabel!
    @IBOutlet var ratingSlider: UISlider!
    @IBOutlet var cosmosViewFull: CosmosView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var commLabel: UILabel!
    @IBOutlet var descrpitionLabel: UILabel!
    @IBOutlet var imageProduct: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
