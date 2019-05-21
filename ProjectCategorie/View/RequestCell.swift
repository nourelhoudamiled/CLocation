//
//  RequestCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 10/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {

    @IBOutlet var imageProduit: UIImageView!

    @IBOutlet var confirmeButton: UIButton!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dateFin: UILabel!
    @IBOutlet var dateDebut: UILabel!
    @IBOutlet var nameProduit: UILabel!
    var linkto: LocationRequestedController?

    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        confirmeButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        confirmeButton.frame = CGRect(x: 333, y: 0, width: 50, height: 50)
        confirmeButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
    }
    @objc private func handleMarkAsFavorite() {
        print("Marking as confirm")
        linkto?.someMethodIWantToCall(cell: self)
        
        
    }
}
//extension RequestCell {
//    func  setCollectionViewDataSourceDelegate <D: UICollectionViewDelegate & UICollectionViewDataSource>(_ dataSourceDelegate : D , forRow row : Int){
//    collectionView.delegate = dataSourceDelegate
//        collectionView.dataSource = dataSourceDelegate
//       collectionView.reloadData()
//
//    }
//
//}
