//
//  HomeCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 21/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import MMBannerLayout
class HomeCell: UITableViewCell {

    @IBOutlet var prixLabel: UILabel!
    @IBOutlet var nameProduit: UILabel!
    @IBOutlet var ratingCosmos: CosmosView!
    @IBOutlet var imageProduit: UIImageView!
    @IBOutlet var viewImage: UIView!
    @IBOutlet var collectionView: UICollectionView!
    var productList = [ProductClass]()
      var productImages = [String]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      setUpView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpView() {
        collectionView.dataSource = self
        collectionView.delegate =  self
        self.collectionView.register(UINib.init(nibName: "produitCell", bundle: nil), forCellWithReuseIdentifier: "produitCell")
        
        if let layout = collectionView.collectionViewLayout as? MMBannerLayout {
            // Space every Item
            layout.itemSpace = 5.0
            // Size for banner cell
            layout.itemSize = self.collectionView.frame.insetBy(dx: 40, dy: 40).size
            // scroll to inifite (ex. completed block check your content size is enough to cycle infinite)
            (collectionView.collectionViewLayout as? MMBannerLayout)?.setInfinite(isInfinite: true, completed: { [unowned self]                    (result) in
                // result false mean you cant infinite
            })
            // auto play
            (collectionView.collectionViewLayout as? MMBannerLayout)?.autoPlayStatus = .play(duration: 2.0)
            // angle need to be (0~90)
            layout.angle = 45
        }
    }
    
}
extension HomeCell : BannerLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, focusAt indexPath: IndexPath) {
        print("Focus At \(indexPath)")
    }
}
extension HomeCell :  UICollectionViewDataSource , UICollectionViewDelegate {


        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return productList.count  
        }
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            //The rest of your method ...
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "produitCell", for: indexPath) as! produitCell
            cell.labelName.text = productList[indexPath.row].name
           cell.prixLabel.text = "\(productList[indexPath.row].price)"
         
            
                return cell
        }

    }



