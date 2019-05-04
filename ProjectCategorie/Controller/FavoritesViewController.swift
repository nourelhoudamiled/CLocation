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

    @IBOutlet var tableView: UITableView!
    var favoiriteListId = [Int]()
    var favoiriteList = [Favorite]()
    
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Favorites")!)
    var urlRequest1 = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Products/")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            navigationItem.title = "Mes Favoris"

        }
listFavorites()
    }
    
    func listFavorites() {
            let urlString = urlRequest.url?.absoluteString
            AF.request(urlString! , method : .get).responseJSON {
                response in
                do {
                    if let data = response.data {
                        let itemDetails1 = try JSONDecoder().decode([Favorite].self, from: data)
                        for item1 in itemDetails1 {
                            self.favoiriteList.append(item1)
                        }
    self.tableView.reloadData()
                    }
                    
                }catch let errords {
                    
                    print(errords)
                }
            }
    }

}
extension FavoritesViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      return favoiriteList.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorite") as! FavoriteCell
      cell.nameLabel.text  = favoiriteList[indexPath.row].productName
        cell.prixetuniteLabel.text = "votre prix : 22 par jour "
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



