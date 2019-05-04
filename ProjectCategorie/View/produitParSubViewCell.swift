//
//  produitParSubViewCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 29/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
protocol TableNew {
    func onClickCell(index : Int)
}
class produitParSubViewCell: UICollectionViewCell {
    var cellDelegate : TableNew?
    var index : IndexPath?
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var cosmosView: CosmosView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var produitsImage: UIImageView!
    var linkto: produitParSubCatViewController?
//
//    // kind of cheat and use a hack
   // let starButton = UIButton(type: .system)
    let customView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //xbackgroundColor = .red
        // kind of cheat and use a hack
        
        favoriteButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        favoriteButton.frame = CGRect(x: 333, y: 0, width: 50, height: 50)
        
//        favoriteButton.inputAccessoryView
      //  favoriteButton.inputAccessoryView?.tintColor =  .red
        favoriteButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        cosmosView.didTouchCosmos = didToushCosmos
        cosmosView.didFinishTouchingCosmos = didFinishTouchingCosmos

    }
    @IBAction func detailButton(_ sender: Any) {
        cellDelegate?.onClickCell(index: index!.row)

    }
    static  func formatValue(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
    @objc private func handleMarkAsFavorite() {
        print("Marking as favorite")
        linkto?.someMethodIWantToCall(cell: self)
        
        
    }
    private func didToushCosmos(_ rating : Double) {
        // ratingSlider.value = Float(rating)
        linkto?.methodCosmos(cell: self, rating: rating)
        
    }
    private func didFinishTouchingCosmos(_ rating : Double) {
        linkto?.methodDidfinich(cell: self, rating: rating)
        
    }
}
