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
    
    var names : ProductClass
    var hasFavorited: Bool
}
class produitParSubCatViewController: UIViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()
       createPhoto()

    }
    
    func methodCosmos(cell: produitParSubViewCell , rating : Double) {
        
        cell.ratingLabel.text = produitParSubViewCell.formatValue(rating)
        
        cell.ratingLabel.textColor = UIColor(red: 133/255, green: 116/255, blue: 154/255, alpha: 1)
        
        
    }
    func methodDidfinich( cell: produitParSubViewCell ,rating : Double)  {
        
        cell.ratingLabel.text = produitParSubViewCell.formatValue(rating)
        cell.ratingLabel.textColor = UIColor(red: 183/255, green: 186/255, blue: 204/255, alpha: 1)
        
    }
    func someMethodIWantToCall(cell: UICollectionViewCell) {
    
        guard let indexPathTapped = collectionView.indexPath(for: cell) else { return }
  
        let contact = twoDimensionalArray[indexPathTapped.row].names
        print(contact)
        
        let hasFavorited = twoDimensionalArray[indexPathTapped.row].hasFavorited
        print(hasFavorited)
        twoDimensionalArray[indexPathTapped.row].hasFavorited = !hasFavorited
        cell.inputAccessoryView?.tintColor = hasFavorited ? UIColor.red : .lightGray
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func createPhoto() {
        let urlStringAttachmentsId = urlRequestAttachmentId.url?.absoluteString
        let urlStringImageByAttachmentId = urlRequestImageByAttachmentId.url?.absoluteString
        let urlString = urlRequest.url?.absoluteString
          let urlStringSearchRating = urlRequestSearchRating.url?.absoluteString
        guard let subCategorieID = Share.sharedName.sousCategorie?.id else {
            return
        }
        
        let productURL = urlString! + "\(subCategorieID)"
        print("subCategorieID : \(subCategorieID)")
        
        AF.request(productURL , method : .get).responseJSON {
            response in
            do {
                guard let data = response.data else {return}
                let itemDetails = try JSONDecoder().decode([ProductClass].self, from: data)
                
                for item in itemDetails {
                    self.ProductList.append(item)
                    
                    guard let productId = item.id else {return}
                    print("produit id : \(productId)")
                    let cellData = Expandable(names: item, hasFavorited: true)
                    self.twoDimensionalArray.append(cellData)
                    let productUrl = urlStringAttachmentsId! + "\(productId)/AttachmentsId"
                    let SearchRatingURL = urlStringSearchRating! + "\(productId)"

                    AF.request(productUrl).responseJSON {
                        response in
                        do {
                            guard let data = response.data else {return}
                            let attachements = try JSONDecoder().decode([Attachement].self, from: data)
                            for atachement in attachements {
                                self.attachementListId.append(atachement.id!)
                                guard let  attachementID = atachement.id else {return}
                                let attachementURL = urlStringImageByAttachmentId! + "\(attachementID)/ImageByAttachmentId"
                                
                                AF.request(attachementURL , method : .get ).responseImage {
                                    response in
                                    guard let image = response.data else {return}
                                    print(image)
                            self.responseImages.append( UIImage(data: image) ?? UIImage(named: "pot-1")! )
                                    self.collectionView.reloadData()

                                }
                            }

                            
                            
                        }catch let error {
                            print(error)
                        }
                        
                    }
                    AF.request(SearchRatingURL , method : .get).responseJSON {
                        response in
                        
                        guard let data = response.data else {return}
                        print(response)
                        var notevalue = String(data: data, encoding: .utf8)!
                        if notevalue == "\"NaN\"" {
                            
                            notevalue = "0"
                        }
                        
                        self.ratingNotes.append(notevalue)
                        self.collectionView.reloadData()

                    }
                }
         self.collectionView.reloadData()

              
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
        
        
        cell.nameLabel.text = twoDimensionalArray[index].names.name
        cell.inputAccessoryView?.tintColor = twoDimensionalArray[index].hasFavorited ? UIColor.lightGray : UIColor.red
        if ratingNotes.count > 0 {
            cell.ratingLabel.text = ratingNotes[indexPath.row]
            cell.cosmosView.rating = ratingNotes[indexPath.row] as? Double ?? 0

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
        
        present(vc, animated: true, completion: nil)
        
    }
    
}
