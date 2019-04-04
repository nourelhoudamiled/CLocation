//
//  SearchViewCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 08/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class SearchViewCell: UITableViewCell {
    @IBOutlet weak var nameCategorie: UILabel!
    @IBOutlet weak var imageCategori: UIImageView!
    
    @IBOutlet var arrowImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
