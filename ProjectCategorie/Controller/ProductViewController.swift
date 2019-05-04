//
//  ProductViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 29/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
struct ExpandableNames {
    
    var names : ProductClass
    var hasFavorited: Bool
}


class ProductViewController: UIViewController , UITableViewDelegate , UITableViewDataSource  {
    
    var productList = [Int]()
    var attachementList = [Attachement]()
    var attachementPathFile = [String]()
    var responseImages = [UIImage]()
 
    var urlRequestImageByProductId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    
    var urlRequestImageByAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    
    //   @IBOutlet var downloadImage: UIImageView!
    var urlRequestAttachmentsId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    
    var urlRequestProductsId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/ProductsId")!)
    var note : Double?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var subCategorie : SousCategClass?
    var prodArray = [ProductClass]()
    var ProductList = [ProductClass]()
    var ratingNotes = [String]()
    var showIndexPaths = false
    var RatingList = [Double]()
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/SubCategory/Product/")!)
    var urlRequestSearchRating = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Product/Rating/")!)
    var urlRequestRating = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Rating")!)
    var twoDimensionalArray = [ExpandableNames]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("sous categorie \(Share.sharedName.sousCategorie)")
        activityIndicator.startAnimating()
        ExpandItemsApi()
//        createPhoto()
        
        
    }
 
    func methodCosmos(cell: productTableViewCell , rating : Double) {

        cell.ratingLabel.text = productTableViewCell.formatValue(rating)
        
        cell.ratingLabel.textColor = UIColor(red: 133/255, green: 116/255, blue: 154/255, alpha: 1)
        
        
    }
    func methodDidfinich( cell: productTableViewCell ,rating : Double)  {
        
        cell.ratingLabel.text = productTableViewCell.formatValue(rating)
        cell.ratingLabel.textColor = UIColor(red: 183/255, green: 186/255, blue: 204/255, alpha: 1)
        
    }
    func someMethodIWantToCall(cell: UITableViewCell) {
        //        print("Inside of ViewController now...")
        
        // we're going to figure out which name we're clicking on
        
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        
        let contact = twoDimensionalArray[indexPathTapped.row].names
        print(contact)
        
        let hasFavorited = twoDimensionalArray[indexPathTapped.row].hasFavorited
        print(hasFavorited)
        twoDimensionalArray[indexPathTapped.row].hasFavorited = !hasFavorited
        
        //        tableView.reloadRows(at: [indexPathTapped], with: .fade)
        
        cell.accessoryView?.tintColor = hasFavorited ? UIColor.red : .lightGray
    }
    

    func postFavorite (productId : Int , userId : String) {
        let params = ["productId": productId ,  "userId": userId] as [String : Any]
        
        let urlString = "https://clocation.azurewebsites.net/api/Favorites"
        
        AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            switch response.result {
            case .success:
                print(response)
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
   
    func postFavorite (Id : Int , userId : String) {
        let params = ["productId": Id ,  "userId": userId] as [String : Any]
        
        let urlString = "https://clocation.azurewebsites.net/api/Favorites"
        
        AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            switch response.result {
            case .success:
                print(response)
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    func createPhoto(productId : Int) {
  
        let urlStringImageByProductId = urlRequestImageByProductId.url?.absoluteString

                    let attachementURL = urlStringImageByProductId! + "\(productId)/ImageByAttachmentId"
                    
                    AF.request(attachementURL , method : .get ).responseImage {
                        response in
                        guard let image = response.data else {return}
                        print(image)
                        self.responseImages.append( UIImage(data: image) ?? UIImage(named: "pot-1")! )
                    //    self.tableView.reloadData()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
//
                    }
        
                
      
        
        
    }
    func ExpandItemsApi() {
        
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
                    print("number of product in this catégorie \(self.productList.count)")

                    guard let productIdd = item.id else {
                        return
                    }
                    self.createPhoto(productId: productIdd)
                    let cellData = ExpandableNames(names: item, hasFavorited: true)
                    self.twoDimensionalArray.append(cellData)
                    
                    let SearchRatingURL = urlStringSearchRating! + "\(productIdd)"
                    print("product id  \(productIdd)")
                    print("product name \(item.name)")
                    print("product description \(item.description)")


                    AF.request(SearchRatingURL , method : .get).responseJSON {
                        response in
                        do {
                            guard let data = response.data else {return}
                            print(response)
                            var notevalue = String(data: data, encoding: .utf8)!
                            if notevalue == "\"NaN\"" {
                                
                                notevalue = "0"
                            }

                            self.ratingNotes.append(notevalue)
                           
                            
                        } catch let err {
                            print(err)
                        }
                      
                    }
                    

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }


                }
            }catch let errors {
                
                print(errors)
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            }.resume()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let cell : productTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! productTableViewCell
        //        cell.link = self
        //        let index = indexPath.row
        //        if  cell.accessoryView?.tintColor = twoDimensionalArray[index].hasFavorited : .UIColor.red {
        //
        //        }
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return responseImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : productTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! productTableViewCell
        cell.link = self
        let index = indexPath.row
        
        cell.descrpitionLabel.text = ProductList[index].description
        
        cell.nameProduct.text = twoDimensionalArray[index].names.name
        cell.accessoryView?.tintColor = twoDimensionalArray[index].hasFavorited ? UIColor.lightGray : UIColor.red
        if ratingNotes.count > 0 {
            cell.ratingLabel.text = ratingNotes[indexPath.row]
            cell.cosmosViewFull.rating = ratingNotes[indexPath.row] as? Double ?? 0
            
        }
        
     cell.imageProduct.image = self.responseImages[indexPath.row]
//cell.selectionStyle = .none
        
        cell.cellDelegate = self
        cell.index = indexPath
        
        return cell
    }
    
    
    @IBAction func DetailProduitAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "louerViewController") as! louerViewController
        
        present(vc, animated: true, completion: nil)
    }
    func getProductRequest(byId Id: Int, completion: @escaping (ProductClass?) -> Void) {
        let urlString = "https://clocation.azurewebsites.net/api/Products/\(Id)"
        AF.request(urlString).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let Request = try decoder.decode(ProductClass.self, from: data)
                print(Request)
                print(Request.id!)
            } catch let error {
                print(error)
                completion(nil)
            }
        }
    }
}

extension ProductViewController : TableViewNew {
  
    
    func onClickCell(index: Int) {
        print("\(ProductList[index]) is selected")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "louerViewController") as! louerViewController
        vc.product =  ProductList[index]
        
        present(vc, animated: true, completion: nil)
        
    }
    
}
//    func deleteFavorite (productId : Int) {
//        let urlString = "https://clocation.azurewebsites.net/api/Favorites\(productId)"
//        AF.request(urlString, method: .delete).responseString { response in
//
//            switch response.result {
//            case .success:
//                print(response)
//
//                break
//            case .failure(let error):
//
//                print(error)
//            }
//        }
//    }
