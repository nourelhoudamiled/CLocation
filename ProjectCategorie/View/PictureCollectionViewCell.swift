//
//  PictureCollectionViewCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 14/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
protocol dataCollectionProtocol {
    
    func deleteData (indx : Int )
}
class PictureCollectionViewCell: UICollectionViewCell {
    var delegate : dataCollectionProtocol?
    var index : IndexPath?
    
    @IBOutlet var deleteButo: UIButton!
    @IBAction func deleteButton(_ sender: Any) {
        delegate?.deleteData(indx: index!.row)
    }
    @IBOutlet var imageProduit: UIImageView!
}
