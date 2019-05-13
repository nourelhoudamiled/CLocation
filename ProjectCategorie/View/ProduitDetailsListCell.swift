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

 //   @IBOutlet var collectionImage: UICollectionView!
    var cellDelegate : detailproduit?
    var index : IndexPath?
    @IBOutlet var produitName: UILabel!
   
    @IBOutlet var pager: UIPageControl!
//    @IBOutlet var imageView: UIImageView!
//
//    @IBOutlet var scrollView: UIScrollView!
    var mesannonce: MesAnnoncesViewController?
 //  var responseImage = [UIImage]()
//    let imageView= UIImageView()

    @IBAction func deleteButton(_ sender: Any) {
        cellDelegate?.delete(index: index!.row)

    }
  @IBOutlet var deleteButton: UIButton!
    @IBOutlet var containerDel: UIView!

override init(frame: CGRect) {
    super.init(frame: frame)
//    collectionImage.register(ImageProduitAnnonceCell.self, forCellWithReuseIdentifier: "ImageProduitAnnonceCell"); //register custom UICollectionViewCell class.
//setupViews()
 
}
//    func setupViews(){
//
//
//        collectionImage.delegate = self as? UICollectionViewDelegate
//        collectionImage.dataSource = self as? UICollectionViewDataSource
//
//
//    }
    override func awakeFromNib() {
    super.awakeFromNib()
        containerDel.layer.cornerRadius = 34 / 2
    }
      //  collectionImage.register(ImageProduitAnnonceCell.self, forCellWithReuseIdentifier: "ImageProduitAnnonceCell") //register custom UICollectionViewCell class.
     //   setupViews()
//        guard let sss = mesannonce?.responseImages.count else {return}
//
//        pager.numberOfPages = sss
//        for i in 0..<sss {
//            imageView.frame = CGRect(x: CGFloat(i)*self.bounds.size.width, y: 0 , width: frame.size.width, height: frame.size.height)
//            frame.origin.x = scrollView.frame.size.width * CGFloat(i)
//            frame.size = scrollView.frame.size
//            scrollView.contentSize.width = bounds.size.width*CGFloat(i+1)
//            imageView.contentMode = .scaleToFill
//            imageView.image = mesannonce?.responseImages[i]
//           scrollView.addSubview(imageView)
//        }
//scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(sss)), height: scrollView.frame.size.height)

 

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let page = scrollView.contentOffset.x/scrollView.frame.width
//
//        pager.currentPage = Int(page)
//    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
//        pager.currentPage = Int(pageNumber)
////        pager.currentPageIndicatorTintColor = mesannonce?.responseImages[pager.currentPage]
//    }
 
required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
}
}
//extension ProduitDetailsListCell {
//    func  setCollectionViewDataSourceDelegate <D: UICollectionViewDelegate & UICollectionViewDataSource>(_ dataSourceDelegate : D , forRow row : Int){
//        collectionImage.delegate = dataSourceDelegate
//        collectionImage.dataSource = dataSourceDelegate
//     collectionImage.reloadData()
//
//    }
//
//}
