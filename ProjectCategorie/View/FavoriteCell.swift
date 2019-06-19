//
//  FavoriteCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 02/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
protocol Table{
    
    func onClickCell(index : Int)
}
class FavoriteCell: UITableViewCell {
    var cellDelegate : Table?
    var index : IndexPath?
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var prixetuniteLabel: UILabel!
    @IBOutlet var imageFav: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteRow(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteButton(_ sender: Any) {
        cellDelegate?.onClickCell(index: index!.row)
    }
    
}
