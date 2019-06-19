//
//  FavoritesViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 27/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
class FavoritesViewController: UIViewController {

    @IBOutlet var acitivityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    var favoiriteListId = [Int]()
    var favoiriteList = [Favorite]()
    var responseImages = [UIImage]()
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Favorites/User/")!)
    var urlRequestImageByAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
       var urlRequestId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Products/")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            navigationItem.title = "Mes Favoris"

        }
        acitivityIndicator.startAnimating()
        tableView.rowHeight = 230
listFavorites()
    }
    func searchImage(productId : Int) {
        
        let urlStringImageByAttachmentId = urlRequestImageByAttachmentId.url?.absoluteString
        let attachementURL = urlStringImageByAttachmentId! + "\(productId)/ImageByProductId"
        
        AF.request(attachementURL , method : .get ).responseImage {
            response in
            guard let image = response.data else {return}
            print(image)
            self.responseImages.append( UIImage(data: image) ?? UIImage(named: "EmmaStone")!)
            self.tableView.reloadData()
        }
    }


    func listFavorites() {
            let urlString = urlRequest.url?.absoluteString
        let userDictionnary = UserDefaults.standard.dictionary(forKey: "userDictionnary")
        let id = userDictionnary?["id"] as? String
        let url = urlString! + id!
            AF.request(url , method : .get).responseJSON {
                response in
                do {
                    if let data = response.data {
                        let itemDetails1 = try JSONDecoder().decode([Favorite].self, from: data)
                        for item1 in itemDetails1 {
                            self.favoiriteList.append(item1)
                            guard let id = item1.productId else { return}
                            self.searchImage(productId: id)
                        }
                        self.tableView.reloadData()
                    }
                    
                }catch let errords {
                    
                    print(errords)
                }
            }
        self.acitivityIndicator.stopAnimating()
        self.acitivityIndicator.isHidden = true
    }

}
extension FavoritesViewController : Table {
    func onClickCell(index: Int) {
        self.delete(Id: favoiriteList[index].id!)
        favoiriteList.remove(at : index)
        tableView.reloadData()
    }
 
    func delete (Id : Int ) {
        
        
        let urlString = "https://clocation.azurewebsites.net/api/Favorites/\(Id)"
        
        AF.request(urlString, method: .delete,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            let favorite : String = "you really wanna delete this request"
            
            let alert = UIAlertController(title: "Alert", message: favorite, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (nil) in
                switch response.result {
                case .success:
                    
                    print(response)
           
                    break
                case .failure(let error):
                    
                    print(error)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "no", style: .default, handler: { (nil) in
                return
            }))
            
            self.present(alert, animated: true)
            
        }
    }
    
    
}
extension FavoritesViewController : UITableViewDelegate, UITableViewDataSource {

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      return favoiriteList.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
            return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorite") as! FavoriteCell
        cell.cellDelegate = self
        cell.index = indexPath

      cell.nameLabel.text  = favoiriteList[indexPath.row].productName
         if responseImages.count > indexPath.row {
            cell.imageFav.image = responseImages[indexPath.row]
        }
//            cell.imageCat.image = UIImage(named: favoiriteList[indexPath.section])
//            cell.imageCat.isHidden = false
//            cell.imageCat.layer.cornerRadius = 20.0
//            cell.viewCell.layer.cornerRadius = 10
//
//            cell.viewCell.layer.shadowColor = UIColor.black.cgColor
//            cell.viewCell.layer.shadowOpacity = 1
//            cell.viewCell.layer.shadowOffset = CGSize.zero
//            cell.viewCell.layer.shadowRadius = 10
        
            
            //            cell.accessoryType = .none
            
            
            return cell
    
        }
    
    
    
}



//    func getProduit(productId : Int , ) {
//
//        let urlStringImageByAttachmentId = urlRequestId.url?.absoluteString
//        let attachementURL = urlStringImageByAttachmentId! + "\(productId)"
//
//        AF.request(attachementURL , method : .get ).responseImage {
//            response in
//            guard let product = response.data else {return}
//            let produit = try JSONDecoder().decode(ProductClass.self, from: data)
//
//
//
//        }
//    }
