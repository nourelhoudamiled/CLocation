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
    var hasFavorited: Bool?
}
class produitParSubCatViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    var urlRequestSearchRating = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Product/Rating/")!)
    var ProductList = [ProductClass]()
   // var hasFavorited : Bool!
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
            print(hasFavorited)
            twoDimensionalArray[indexPathTapped.row].hasFavorited = !hasFavorited!

            cell.favoriteButton.tintColor = hasFavorited! ?  UIColor.red : .lightGray
            if (hasFavorited == true) {
                self.postFavorite(Id: ProductList[indexPathTapped.row].id!, userId: "5db395d9-3b02-4c27-bb19-0f4c6ce8b851")
            }
            if (hasFavorited == false) {
                self.deleteFavorite(Id: favoiriteList[indexPathTapped.row].id!)
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
                //                let favorite : String = "vous avez ajouter dans votre favoris"
                //                self.displayMessage(userMessage: favorite)
                
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
            self.collectionView.reloadData()
            
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
                for item in itemDetails {
                    self.ProductList.append(item)
                    self.twoDimensionalArray.append(Expandable(products: item, hasFavorited: true))
                    guard let productId = item.id else {return}
                    print("produit id : \(productId)")
                    self.searchRating (productId : productId)

                let urlString = self.urlRequestfavorite.url?.absoluteString
                    AF.request(urlString! , method : .get).responseJSON {
                        response in
                        do {
                            
                            guard let data = response.data else {return }
                                let itemDetails1 = try JSONDecoder().decode([Favorite].self, from: data)
                                for item1 in itemDetails1 {
                            let cellDatafalse = Expandable(products: item, hasFavorited: false)
                        let cellDatatrue = Expandable(products: item, hasFavorited: true)
                                    if (item.id == item1.productId && item.name == item1.productName)
                                    {
                                        var index : Int?
                                        for i in (0...self.ProductList.count - 1) {
                                            if self.ProductList[i].id == item.id {
                                                index = i
                                            }
                                        }
                                       
                                        self.twoDimensionalArray[index ?? 0] = cellDatafalse
                                        print("celldata false  : \(cellDatafalse)")
                                        self.collectionView.reloadData()

                                    }
                                    self.favoiriteList.append(item1)



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
        
        cell.linkto = self
        let index = indexPath.row
    
        cell.nameLabel.text = ProductList[index].name
        if twoDimensionalArray.count > 0 {
            
                    if twoDimensionalArray[index].hasFavorited == true {
                        cell.favoriteButton.tintColor = UIColor.lightGray
                    }
                    else if  twoDimensionalArray[index].hasFavorited == false {
                    cell.favoriteButton.tintColor =  UIColor.red
                    }
        }

        if ratingNotes.count > 0 {
            cell.ratingLabel.text = ratingNotes[indexPath.row]
            cell.cosmosView.rating = Double(ratingNotes[indexPath.row]) ?? 0
            
        }
        
        cell.produitsImage.image = self.responseImages[indexPath.row]
        cell.cellDelegate = self
        cell.index = indexPath
        
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
    
}
