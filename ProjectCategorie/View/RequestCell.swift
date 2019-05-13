//
//  RequestCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 10/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dateFin: UILabel!
    @IBOutlet var dateDebut: UILabel!
    @IBOutlet var nameProduit: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension RequestCell {
    func  setCollectionViewDataSourceDelegate <D: UICollectionViewDelegate & UICollectionViewDataSource>(_ dataSourceDelegate : D , forRow row : Int){
    collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.reloadData()

    }

}
