//
//  ListProductViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 25/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import ASCollectionView
import Alamofire
import AlamofireImage
class ListProductViewController: UIViewController , ASCollectionViewDataSource, ASCollectionViewDelegate  {

    @IBOutlet var collectionView: ASCollectionView!
    var numberOfItems: Int = 10
   
    var productList = [Int]()
    var ProductLis = [ProductClass]()

    var attachementList = [Attachement]()
      var attachementPathFile = [String]()
      var responseImages = [UIImage]()
    var urlRequestImageByProductId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)

    var urlRequestImageByAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)

//   @IBOutlet var downloadImage: UIImageView!
    var urlRequestAttachmentsId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)

    var urlRequestProductsId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/ProductsId")!)

    let collectionElementKindHeader = "Header"
    let collectionElementKindMoreLoader = "MoreLoader"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let subCategorieID = Share.sharedName.sousCategorie?.id
        print(subCategorieID)
 //   getAttachement()
      createPhoto()
        collectionView.register(UINib(nibName: collectionElementKindHeader, bundle: nil), forSupplementaryViewOfKind: collectionElementKindHeader, withReuseIdentifier: "header")
        collectionView.asDataSource = self
    }
    func createPhoto() {
            var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/SubCategory/Product/")!)
        let urlStringProductsId = urlRequestImageByAttachmentId.url?.absoluteString
        let urlStringImageByProductId = urlRequestImageByProductId.url?.absoluteString
        let urlString = urlRequest.url?.absoluteString
        
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
                    self.ProductLis.append(item)
                    print("number of product in this catégorie \(self.productList.count)")
                    guard let productIdd = item.id else {return}
                    let productUrl = urlStringProductsId! + "\(productIdd)/AttachmentsId"
        AF.request(productUrl).responseJSON {
            response in
            do {
                guard let data = response.data else {return}
                let attachements = try JSONDecoder().decode([Attachement].self, from: data)
                for atachement in attachements {
                    self.productList.append(atachement.id!)
                    guard let  productID = atachement.id else {return}
                    let attachementURL = urlStringImageByProductId! + "\(productID)/ImageByAttachmentId"
                    
                    AF.request(attachementURL , method : .get ).responseImage {
                        response in
                        guard let image = response.data else {return}
                        print(image)
                        self.responseImages.append( UIImage(data: image) ?? UIImage(named: "pot-1")! )
                        //    self.tableView.reloadData()
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        //
                    }
                }
                
                
            }catch let error {
                print(error)
            }
            
                    }
                }
                }catch let errors {
                        
                        print(errors)
                }
        
        
    }
    }
//    func createPhoto() {
//
//            let urlStringProductsId = urlRequestProductsId.url?.absoluteString
//            let urlStringImageByProductId = urlRequestImageByProductId.url?.absoluteString
//            AF.request(urlStringProductsId!).responseJSON {
//                response in
//                do {
//                    guard let data = response.data else {return}
//                    let ProductIdListJson = try JSONDecoder().decode([Attachement].self, from: data)
//                    for product in ProductIdListJson {
//                        self.attachementList.append(product)
//                       print( self.productList.count)
//                        guard let  productID = product.productId else {return}
//                        let attachementURL = urlStringImageByProductId! + "\(productID)/ImageByProductId"
//                        print(productID)
//
//                     let parameters = ["ProductId": "\(productID)"]
//                        AF.upload(multipartFormData: { (form: MultipartFormData) in
//                            for pictures in self.photo {
//                                if let data = pictures.jpegData(compressionQuality: 0.75) {
//                                    form.append(data, withName: "files",fileName: "file.jpg", mimeType: "image/jpg")
//                                }
//                            }
//                            for (key, value) in parameters
//                            {
//                                form.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                            }
//
//                        }, usingThreshold: MultipartFormData.encodingMemoryThreshold, to: attachementURL, method: .get).responseImage { (response)in
//                            // Show the downloaded image:
//                            guard let image = response.data else {return}
//                            print(image)
//
//                       //     self.photo = [UIImage(data: image)] as! [UIImage]
////
//                            for pictures in self.photo {
//                            if let data = pictures.jpegData(compressionQuality: 0.75) {
//                                        self.photo.append(UIImage(data: data)!)
//                                        print(self.photo)
//
//
//                                    }
//                                }
//                          //  print(self.photo)
//                             //   print(data)
//     self.collectionView.reloadData()
////                          self.downloadImage.image = UIImage(data: image)
//
//                        }
//
//                    }
//                   self.collectionView.reloadData()
//
//                }catch let error {
//                    print(error)
//                }
//
//        }
//
//
//    }

    
    
//    func getAttachement(){
//        let urlString = urlRequest.url?.absoluteString
//        AF.request(urlString! , method : .get).responseJSON {
//            response in
//            do {
//                guard  let data = response.data else {return }
//                    let itemDetails1 = try JSONDecoder().decode([Attachement].self, from: data)
//                    for item1 in itemDetails1 {
//                        self.attachementList.append(item1)
//                    }
//                print(self.attachementList)
//                    self.collectionView.reloadData()
//
//
//            }catch let errords {
//
//                print(errords)
//            }
//        }
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: ASCollectionViewDataSource
    
    func numberOfItemsInASCollectionView(_ asCollectionView: ASCollectionView) -> Int {
        print(attachementList.count)
        return responseImages.count
    }
    
    func collectionView(_ asCollectionView: ASCollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GridCell
        gridCell.label.text = attachementList[indexPath.row].productName
        gridCell.imageView.image = responseImages[indexPath.row]
        //"photo[indexPath.row]"
        return gridCell
    }
    
    func collectionView(_ asCollectionView: ASCollectionView, parallaxCellForItemAtIndexPath indexPath: IndexPath) -> ASCollectionViewParallaxCell {
        let parallaxCell = collectionView.dequeueReusableCell(withReuseIdentifier: "parallaxCell", for: indexPath) as! ParallaxCell
        parallaxCell.label.text = "bbb"
        parallaxCell.updateParallaxImage(UIImage(named: "contact")!)
        return parallaxCell
    }
    
    func collectionView(_ asCollectionView: ASCollectionView, headerAtIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: ASCollectionViewElement.Header, withReuseIdentifier: "header", for: indexPath)
        return header
    }
    
//    func loadMoreInASCollectionView(_ asCollectionView: ASCollectionView) {
//        if numberOfItems > 30 {
//            collectionView.enableLoadMore = false
//            return
//        }
//        numberOfItems += 10
//        collectionView.loadingMore = false
//        collectionView.reloadData()
//    }
//
}
 class ParallaxCell: ASCollectionViewParallaxCell {
    
    @IBOutlet var label: UILabel!
}
