//
//  produitParSubCatViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 29/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
struct Expandable {
    
   // var names : String?
   //var favorite: Favorite?
     var products: ProductClass?
    var idFavoris : Int?
    var hasFavorited: Bool?
}
class produitParSubCatViewController: UIViewController {
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    @IBOutlet var collectionView: UICollectionView!
    var urlRequestSearchRating = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Product/Rating/")!)
    var ProductList = [ProductClass]()
    var attachementListId = [Int]()
    var attachementPathFile = [String]()
    var responseImages = [UIImage]()
    var ratingNotes = [String]()
    var urlRequestImageByAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    var urlRequestAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/SubCategory/Product/")!)
    var twoDimensionalArray = [Expandable]()
    var favoiriteList = [Favorite]()
    
    var urlRequestfavorite = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Favorites")!)
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
     expendlistproduit()
        activityIndicator.startAnimating()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  expendlistproduit()
    }
    
    func methodCosmos(cell: produitParSubViewCell , rating : Double) {
        
        cell.ratingLabel.text = produitParSubViewCell.formatValue(rating)
        
        cell.ratingLabel.textColor = UIColor(red: 133/255, green: 116/255, blue: 154/255, alpha: 1)
        
        
    }
    func methodDidfinich( cell: produitParSubViewCell ,rating : Double)  {
        guard let indexPathTapped = collectionView.indexPath(for: cell) else { return }
        
        cell.ratingLabel.text = produitParSubViewCell.formatValue(rating)
        cell.ratingLabel.textColor = UIColor(red: 183/255, green: 186/255, blue: 204/255, alpha: 1)
        postRating (Id : ProductList[indexPathTapped.row].id! , userId : "83a22f90-ef02-40bc-971e-2cda1296bf01" , note : rating)
        
    }
    func someMethodIWantToCall(cell: produitParSubViewCell) {
        
        guard let indexPathTapped = collectionView.indexPath(for: cell) else { return }
        if twoDimensionalArray.count > 0 {
            let hasFavorited = twoDimensionalArray[indexPathTapped.row].hasFavorited
            twoDimensionalArray[indexPathTapped.row].hasFavorited = !hasFavorited!

            cell.favoriteButton.tintColor = hasFavorited! ?  UIColor.lightGray : .red
            if (hasFavorited == false) {
                self.postFavorite(Id: ProductList[indexPathTapped.row].id!, userId: "5db395d9-3b02-4c27-bb19-0f4c6ce8b851")
            }
            if (hasFavorited == true) {
                self.deleteFavorite(Id: twoDimensionalArray[indexPathTapped.row].idFavoris ?? 0)
            }
        }

        
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func postFavorite (Id : Int , userId : String) {
        let params = ["productId": Id ,  "userId": userId] as [String : Any]
        
        let urlString = "https://clocation.azurewebsites.net/api/Favorites"
        
        AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            switch response.result {
            case .success:
                print(response)
                let favorite : String = "vous avez ajouter dans votre favoris"
                self.ProductList.removeAll()
                self.expendlistproduit2()
             self.displayMessage(userMessage: favorite)
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func deleteFavorite (Id : Int) {
       
        
        let urlString = "https://clocation.azurewebsites.net/api/Favorites/\(Id)"
        
        AF.request(urlString, method: .delete,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            switch response.result {
            case .success:
                print(response)
                let favorite : String = "vous avez supprimer cette favoris"
                self.displayMessage(userMessage: favorite)
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    func postRating (Id : Int , userId : String , note : Double) {
        let params = ["productId": Id ,  "userId": userId , "note": note] as [String : Any]
        
        let urlString = "https://clocation.azurewebsites.net/api/Rating"
        
        AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            switch response.result {
            case .success:
                print(response)
                                let favorite : String = "vous avez ajouter dans votre favoris"
                                self.displayMessage(userMessage: favorite)
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func searchRating (productId : Int) {
        
        let urlStringSearchRating = urlRequestSearchRating.url?.absoluteString
        let SearchRatingURL = urlStringSearchRating! + "\(productId)"
        
        AF.request(SearchRatingURL , method : .get).responseJSON {
            response in
            
            guard let data = response.data else {return}
            print("response\(response)")
            var notevalue = String(data: data, encoding: .utf8)!
            print("notevalue\(notevalue)")
            if notevalue == "\"NaN\"" {
                
                notevalue = "0"
            }
            self.ratingNotes.append(notevalue)
            self.searchImage(productId : productId)
//            self.collectionView.reloadData()
            
        }
    }
    func searchImage(productId : Int) {
        
        let urlStringImageByAttachmentId = urlRequestImageByAttachmentId.url?.absoluteString
        let attachementURL = urlStringImageByAttachmentId! + "\(productId)/ImageByProductId"
        
        AF.request(attachementURL , method : .get ).responseImage {
            response in
            guard let image = response.data else {return}
            print(image)
            self.responseImages.append( UIImage(data: image) ?? UIImage(named: "Maisson")!)
            self.collectionView.reloadData()
        }
    }
    func expendlistproduit() {
        let urlString = urlRequest.url?.absoluteString
        guard let subCategorieID = Share.sharedName.sousCategorie?.id else {return}
        let productURL = urlString! + "\(subCategorieID)"
        print("subCategorieID : \(subCategorieID)")

        AF.request(productURL , method : .get).responseJSON {
            response in
            do {
                guard let data = response.data else {return}

                let itemDetails = try JSONDecoder().decode([ProductClass].self, from: data)
//                self.ProductList.removeAll()

                for item  in itemDetails {
                    self.ProductList.append(item)
                    self.twoDimensionalArray.append(Expandable(products: item, idFavoris: nil, hasFavorited: false))

                    guard let productId = item.id else {return}
                    self.searchRating (productId : productId)

                let urlString = self.urlRequestfavorite.url?.absoluteString
                    AF.request(urlString! , method : .get).responseJSON {
                        response in
                        do {
                            guard let data = response.data else {return }
                                let itemDetails1 = try JSONDecoder().decode([Favorite].self, from: data)
                                for  item1 in itemDetails1{
                                    
                                    if (item.id == item1.productId && item.name == item1.productName)
                                    {
                                        var index : Int?
                                        for i in (0...self.ProductList.count - 1) {
                                            if self.ProductList[i].id == item1.productId {
                                                index = i
                                            }
                                        }
                                        self.twoDimensionalArray[index ?? 0 ] = Expandable(products: item, idFavoris: item1.id, hasFavorited: true)

                                    }
                                    self.favoiriteList.append(item1)



                                }
                              self.collectionView.reloadData()
                        }catch let errords {

                            print(errords)
                        }
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                
                 self.collectionView.reloadData()
            }catch let errors {
                print(errors)
            }
            
        }
        
        
    }
    func expendlistproduit2() {
        let urlString = urlRequest.url?.absoluteString
        guard let subCategorieID = Share.sharedName.sousCategorie?.id else {return}
        let productURL = urlString! + "\(subCategorieID)"
        print("subCategorieID : \(subCategorieID)")
        
        AF.request(productURL , method : .get).responseJSON {
            response in
            do {
                guard let data = response.data else {return}
                
                let itemDetails = try JSONDecoder().decode([ProductClass].self, from: data)
                //                self.ProductList.removeAll()
                
                for item  in itemDetails {
                    self.ProductList.append(item)
                    self.twoDimensionalArray.append(Expandable(products: item, idFavoris: nil, hasFavorited: false))
                    
                    guard let productId = item.id else {return}
//                    self.searchRating (productId : productId)
                    
                    let urlString = self.urlRequestfavorite.url?.absoluteString
                    AF.request(urlString! , method : .get).responseJSON {
                        response in
                        do {
                            guard let data = response.data else {return }
                            let itemDetails1 = try JSONDecoder().decode([Favorite].self, from: data)
                            for  item1 in itemDetails1{
                                
                                if (item.id == item1.productId && item.name == item1.productName)
                                {
                                    var index : Int?
                                    for i in (0...self.ProductList.count - 1) {
                                        if self.ProductList[i].id == item1.productId {
                                            index = i
                                        }
                                    }
                                    self.twoDimensionalArray[index ?? 0 ] = Expandable(products: item, idFavoris: item1.id, hasFavorited: true)
                                    
                                }
                                self.favoiriteList.append(item1)
                                self.collectionView.reloadData()
                                
                                
                                
                            }
                        }catch let errords {
                            
                            print(errords)
                        }
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                
                
            }catch let errors {
                print(errors)
            }
            
        }
        
        
    }
}
extension produitParSubCatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responseImages.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "list", for: indexPath) as! produitParSubViewCell
        cell.cellDelegate = self
        cell.index = indexPath
        cell.linkto = self
        let index = indexPath.row
        if ProductList.count > 0 {
        cell.nameLabel.text = ProductList[index].name
        }
        if twoDimensionalArray.count > 0 {

                    if twoDimensionalArray[index].hasFavorited == true {
                        cell.favoriteButton.tintColor = UIColor.red
                    }
                    else
                    {
                    cell.favoriteButton.tintColor =  UIColor.lightGray
                    }
        }


        if responseImages.count > 0 {
            cell.produitsImage.image = self.responseImages[indexPath.row]
        }
            cell.ratingLabel.text = ratingNotes[indexPath.row]
            cell.cosmosView.rating = Double(ratingNotes[indexPath.row]) ?? 0
        
       
     
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.backgroundColor = UIColor.white
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        //        cell.favoriteButton.inputAccessoryView
        
        return cell
    }
}
// extention for UICollectionViewDelegateFlowLayout
extension produitParSubCatViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let heightVal = self.view.frame.height
        let widthVal = self.view.frame.width
        let cellsize = (heightVal < widthVal) ?  bounds.height/2 : bounds.width/2
        
        return CGSize(width: cellsize - 10   , height:  cellsize - 10  )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}//end of extension  ViewController
extension produitParSubCatViewController : TableNew {
    
    
    func onClickCell(index: Int) {
        print("\(ProductList[index]) is selected")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "louerViewController") as! louerViewController
        vc.product =  ProductList[index]
        Share.sharedName.product =  ProductList[index]
        
        
        present(vc, animated: true, completion: nil)
        
    }
    

    
    //my custom zooming logic
    func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
             //   self.inputContainerView.alpha = 0
                
                // math?
                // h2 / w1 = h1 / w1
                // h2 = h1 / w1 * w1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
            }, completion: { (completed) in
                //                    do nothing
            })
            
        }
    }
    
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            //need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
               // self.inputContainerView.alpha = 1
                
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
    
}
