//
//  productTableViewCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 29/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
protocol TableViewNew {
    
    func onClickCell(index : Int)
}
class productTableViewCell: UITableViewCell {
    var cellDelegate : TableViewNew?
    

    var index : IndexPath?
    @IBOutlet var nameProduct: UILabel!
   var link: ProductViewController?
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var cosmosViewFull: CosmosView!


    @IBOutlet var descrpitionLabel: UILabel!
    @IBOutlet var imageProduct: UIImageView!
    
    
    // kind of cheat and use a hack
    let starButton = UIButton(type: .system)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
             //xbackgroundColor = .red
        // kind of cheat and use a hack
        
        starButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        starButton.frame = CGRect(x: 333, y: 0, width: 50, height: 50)
        
//        starButton.tintColor = .red
        starButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        cosmosViewFull.didTouchCosmos = didToushCosmos
        cosmosViewFull.didFinishTouchingCosmos = didFinishTouchingCosmos
        
        
      //  accessoryView = starButton
    }
  static  func formatValue(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
    @objc private func handleMarkAsFavorite() {
         print("Marking as favorite")
        link?.someMethodIWantToCall(cell: self)
     
        
    }
    private func didToushCosmos(_ rating : Double) {
        // ratingSlider.value = Float(rating)
    link?.methodCosmos(cell: self, rating: rating)
        
    }
    private func didFinishTouchingCosmos(_ rating : Double) {
       link?.methodDidfinich(cell: self, rating: rating)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func detailAction(_ sender: Any) {
        cellDelegate?.onClickCell(index: index!.row)
       
    }
 
}
