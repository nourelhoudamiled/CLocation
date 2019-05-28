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
struct CellD  {
    
    var produits =  [ProductClass]()
    //    var image = [UIImage]()
    var images = [UIImage]()
    var ratings =  [String]()
    var title = String()
}
class HomeController: UIViewController , UISearchBarDelegate {
    var urlRequestSearchRating = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Product/Rating/")!)
    var urlRequestImageByAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    var urlRequestProduit = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Products")!)
    var ratingNotes = [String]()
    var responseImages = [UIImage]()
    var tablecell = [CellD]()
     var ProduitList = [ProductClass]()
 var CurrentproduitList = [CellD]()
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllProduit()
        UITabBar.appearance().barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        if revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        
            let banner = UIImage(named: "clocation")
            let imageView = UIImageView(image:banner)
            let bannerWidth = navigationController?.navigationBar.frame.size.width
            let bannerHeight = navigationController?.navigationBar.frame.size.height
            let bannerx = bannerWidth! / 2 - banner!.size.width / 2
            let bannery = bannerHeight! / 2 - banner!.size.height / 2
            imageView.frame = CGRect(x: bannerx, y: bannery, width: bannerWidth!, height: bannerHeight!)
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            self.navigationItem.titleView = imageView

        }
          setUpSearchBar()
        
        self.tableView.register(UINib( nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        activityIndicator.startAnimating()
        tableView.rowHeight = 315

        
    }
    func setUpSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        
        //        searchBar.delegate = self
        
        let scb = searchController.searchBar
        scb.delegate = self
        scb.tintColor = UIColor.white
        scb.barTintColor = UIColor.white
        
        
        if let textfield = scb.value(forKey: "searchField") as? UITextField {
            //textfield.textColor = // Set text color
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
                
            }
        }
        
   
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        CurrentproduitList = tablecell.filter({ cat -> Bool in
            
            if searchText.isEmpty { return true }
            return cat.title.lowercased().contains(searchText.lowercased())
            
        })
        tableView.reloadData()
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
           // self.searchImage(productId : productId)
            
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
        let urlStringSearchRating = urlRequestSearchRating.url?.absoluteString
        AF.request(urlString! , method : .get).responseJSON {
            response in
            do {
                print("response \(response)")
                guard let data = response.data else {return}
                let itemDetails = try JSONDecoder().decode([ProductClass].self, from: data)
                print("item detaile \(itemDetails)")
              //  self.ProduitList.removeAll()

                for item  in itemDetails {
                    self.ProduitList.append(item)
                    guard let productId = item.id else {return}
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

                        let cellData = CellD(produits : self.ProduitList ,  images: self.responseImages , ratings: self.ratingNotes , title: item.name!)
                        self.tablecell.append(cellData)
                        self.CurrentproduitList = self.tablecell
                        print("ProduitListp\(self.ProduitList.count)")
                        print("ProduitListr\(self.ratingNotes.count)")
                        print("ProduitListres\(self.responseImages.count)")
                        
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true


                    }
                   // self.tableView.reloadData()

                   


                }
                

            }catch let errors {
                print(errors)
            }
           
        }
        
    }
    
    
}
extension HomeController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentproduitList[section].images.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return CurrentproduitList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        let index = indexPath.row
        if CurrentproduitList.count > 0 {
        cell.prixLabel.text = "\(CurrentproduitList[indexPath.section].produits[index].price!) $"
        cell.nameProduit.text =  CurrentproduitList[indexPath.section].title
            if responseImages.count > 0 {
                cell.imageProduit.image = CurrentproduitList[indexPath.section].images[index]
            }
            if ratingNotes.count > 0 {
                cell.ratingCosmos.rating = Double(CurrentproduitList[indexPath.section].ratings[index]) ?? 0
            }
        }
      
        
       
        cell.selectionStyle = .none
      
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
            
        print("\(ProduitList[indexPath.row]) is selected")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "louerViewController") as! louerViewController
        vc.product = CurrentproduitList[indexPath.section].produits[indexPath.row]
        Share.sharedName.product = CurrentproduitList[indexPath.section].produits[indexPath.row]
        

       self.navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true, completion: nil)
        
    }
   

}

