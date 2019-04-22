//
//  ProductViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 29/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
class ProductViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    
    var note : Double?
    @IBOutlet var tableView: UITableView!
    var subCategorie : SousCategClass?
    var prodArray = [ProductClass]()
    var ProductList = [ProductClass]()
     var RatingList = [Double]()
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/SubCategory/Product/")!)
        var urlRequestSearchRating = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Product/Rating/")!)
         var urlRequestRating = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Rating")!)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ExpandItemsApi()
       
        
        
    }
    func someMethodIWantToCall(cell: UITableViewCell) {
                print("Inside of ViewController now...")
        
        // we're going to figure out which name we're clicking on
        
        let indexPathTapped = tableView.indexPath(for: cell)
        print("indexPathTapped : \(indexPathTapped)")
        let contact = ProductList[indexPathTapped!.row]
        print(contact)
//    let hasFavorited = contact.hasFavorited
//        ProductList[indexPathTapped!.row].hasFavorited = !hasFavorited!
//        
//     
//        
//        cell.accessoryView?.tintColor = hasFavorited! ? UIColor.lightGray : .red
    }
  
//    func ratingData () {
//        let urlStringRating = urlRequest.url?.absoluteString
//        AF.request(urlStringRating! , method: .get).responseJSON {
//            response in
//            do {
//                guard let data = response.data else {return}
//
//                let itemDetails = try JSONDecoder().decode([Rating].self, from: data)
//                for item in itemDetails {
//                    self.RatingList.append(item)
//                    print("item\(item)")
//                }
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//
//            }catch let errors {
//
//                print(errors)
//            }
//
//
//            }.resume()
//
//    }
    func ExpandItemsApi() {
        
        let urlString = urlRequest.url?.absoluteString
        let urlStringSearchRating = urlRequestSearchRating.url?.absoluteString
        
        guard let subCategorieID = subCategorie?.id else {
            return
        }
        let productURL = urlString! + "\(subCategorieID)"
        
        AF.request(productURL , method : .get).responseJSON {
            response in
            do {
                  if let data = response.data {
                let itemDetails = try JSONDecoder().decode([ProductClass].self, from: data)
                
                for item in itemDetails {
                    self.ProductList.append(item)
                    guard let productIdd = item.id else {
                        return
                    }
                    let SearchRatingURL = urlStringSearchRating! + "\(productIdd)"
                    AF.request(SearchRatingURL , method : .get).responseJSON {
                        response in
                        do {

                            self.note = response.value as? Double
                            
                            print("note\(self.note)")
                        
//                            print( "aa\(self.RatingList.append((response.value as? Double ?? 2)))")

                        
                            
//                            var RatingList = [Rating]()
//
//                              if let data = response.data {
//                            let Details = try JSONDecoder().decode([Rating].self, from: data)
//
//                            for items in Details {
//                                RatingList.append(Rating(note: items.note! ))
//                                print(items)
//                            }
//
//                                print("RatingList\(RatingList)")
//                            print("Details\(Details)")
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                           // }
                        } catch let err {
                            print(err)
                        }
                    }
  
                }
               
                }
                
            }catch let errors {
                
                print(errors)
            }
            
            
            }.resume()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : productTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! productTableViewCell
       cell.link = self
        let index = indexPath.row

        cell.descrpitionLabel.text = ProductList[index].description

        cell.nameProduct.text = ProductList[index].name
//        cell.accessoryView?.tintColor = ProductList[index].hasFavorited! ? UIColor.red : .lightGray
     
        if let _ = note {
            cell.ratingLabel.text = "\(note)"
            cell.cosmosViewFull.rating = note ?? 0

        }
     
        cell.cellDelegate = self
        cell.index = indexPath
    
        return cell
    }
    
    
//    @IBAction func DetailProduitAction(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "louerViewController") as! louerViewController
////        vc.text = tableView?(tableView, didSelectRowAt: index)
//
//        present(vc, animated: true, completion: nil)
//    }
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
