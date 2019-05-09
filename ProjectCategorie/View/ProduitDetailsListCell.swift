//
//  ProduitDetailsListCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 06/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
protocol detailproduit {
    
    func delete(index : Int )
   
}
class ProduitDetailsListCell: UICollectionViewCell {
    var cellDelegate : detailproduit?
    var index : IndexPath?
    @IBOutlet var produitImage: UIImageView!
    @IBOutlet var produitName: UILabel!
    
    @IBAction func deleteButton(_ sender: Any) {
        cellDelegate?.delete(index: index!.row)

    }
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var containerDel: UIView!

override init(frame: CGRect) {
    super.init(frame: frame)
    
}
    override func awakeFromNib() {
    super.awakeFromNib()
        containerDel.layer.cornerRadius = 34 / 2

}
required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
}
}
