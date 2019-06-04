//
//  produitParSubViewCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 29/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import FaveButton


func color(_ rgbColor: Int) -> UIColor{
    return UIColor(
        red:   CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
        blue:  CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
        alpha: CGFloat(1.0)
    )
}
protocol TableNew {
}
class produitParSubViewCell: UICollectionViewCell {
    var cellDelegate : TableNew?
    var index : IndexPath?
    @IBOutlet var favoriteButton: FaveButton!
     @IBOutlet var viewProduit: UIView!
    @IBOutlet var cosmosView: CosmosView!
    @IBOutlet var prixLabel: UILabel!
    @IBOutlet var produitsImage: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    var linkto: produitParSubCatViewController?
//
    @IBOutlet var userLabel: UILabel!
    //    // kind of cheat and use a hack
   // let starButton = UIButton(type: .system)
    let customView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))

    override func awakeFromNib() {
        super.awakeFromNib()
        viewProduit.alpha = 1 // 50% opacity

        // Initialization code
        //xbackgroundColor = .red
        // kind of cheat and use a hack
        
//        favoriteButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
//        favoriteButton.frame = CGRect(x: 333, y: 0, width: 50, height: 50)
        
//        favoriteButton.inputAccessoryView
      //  favoriteButton.inputAccessoryView?.tintColor =  .red
        favoriteButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)


    }
 
    static  func formatValue(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
    @objc private func handleMarkAsFavorite() {
        print("Marking as favorite")
       
//        viewProduit.backgroundColor = UIColor.black.withAlphaComponent(0.75)
//        viewProduit.isOpaque = false
       
        linkto?.someMethodIWantToCall(cell: self)


    }
    let colors = [
        DotColors(first: color(0x7DC2F4), second: color(0xE2264D))
      
    ]
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        print ("aaa")
         //linkto?.someMethodIWantToCall(cell: self)
    }
    
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?{
        if( faveButton === favoriteButton ){
            return colors
        }
        return nil
    }
  
}
