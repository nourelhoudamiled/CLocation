//
//  TestViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 04/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
class HomeController: UIViewController {
    var urlRequestSearchRating = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Product/Rating/")!)
    var urlRequestImageByAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    var urlRequestProduit = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Products")!)
    var ratingNotes = [String]()
    var responseImages = [UIImage]()
    var ProduitList = [ProductClass]()

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllProduit()
        if revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            navigationItem.title = "Home "

        }
        
        self.tableView.register(UINib( nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        activityIndicator.startAnimating()
        tableView.rowHeight = 315

        
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
            
        }
    }
    func searchImage(productId : Int) {
        
        let urlStringImageByAttachmentId = urlRequestImageByAttachmentId.url?.absoluteString
        let attachementURL = urlStringImageByAttachmentId! + "\(productId)/ImageByProductId"
        
        AF.request(attachementURL , method : .get ).responseImage {
            response in
            guard let image = response.data else {return}
            self.responseImages.append( UIImage(data: image) ?? UIImage(named: "Agricole")!)
            self.tableView.reloadData()
        }
    }
    func getAllProduit() {
        
        let urlString = urlRequestProduit.url?.absoluteString
     
        AF.request(urlString! , method : .get).responseJSON {
            response in
            do {
                print("response \(response)")
                guard let data = response.data else {return}
                let itemDetails = try JSONDecoder().decode([ProductClass].self, from: data)
                print("item detaile \(itemDetails)")
                for item  in itemDetails {
                    self.ProduitList.append(item)
                    guard let productId = item.id else {return}
                    self.searchRating(productId: productId)
                    
                }
                
                
            }catch let errors {
                print(errors)
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        
    }
    
    
}
extension HomeController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseImages.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        let index = indexPath.row
        if ProduitList.count > 0 {
        cell.prixLabel.text = "\(ProduitList[index].price!) $"
        cell.nameProduit.text =  ProduitList[index].name!
        }
        if responseImages.count > 0 {
        cell.imageProduit.image = responseImages[index]
        }
        if ratingNotes.count > 0 {
        cell.ratingCosmos.rating = Double(ratingNotes[indexPath.row]) ?? 0
        }
        cell.selectionStyle = .none
      
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
            
        print("\(ProduitList[indexPath.row]) is selected")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "louerViewController") as! louerViewController
        vc.product =  ProduitList[indexPath.row]
        Share.sharedName.product =  ProduitList[indexPath.row]
        

       self.navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true, completion: nil)
        
    }
   

}

