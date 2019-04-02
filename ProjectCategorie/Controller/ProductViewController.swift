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
 
    @IBOutlet var tableView: UITableView!
    var subCategorie : SousCategClass?
   var prodArray = [ProductClass]()
       var ProductList = [ProductClass]()
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/SubCategory/Product/")!)

    override func viewDidLoad() {
        super.viewDidLoad()
 ExpandItemsApi()
print(subCategorie!)
      
   
    }
    func ExpandItemsApi() {
        
        let urlString = urlRequest.url?.absoluteString
        guard let ids = subCategorie?.id else {
            return
        }
        AF.request(urlString!+"\(ids)").responseJSON {
            response in
            do {
                
                let itemDetails = try JSONDecoder().decode([ProductClass].self, from: response.data!)
               
                for item in itemDetails {
                    self.ProductList.append(item)
//                    self.catArray.append(CategorieClass(name: item.name!))
                    
                }
                self.prodArray = self.ProductList
                //  self.catArray.append(CategorieClass(name: item.name!))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
        return prodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : productTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! productTableViewCell
cell.descrpitionLabel.text = prodArray[indexPath.row].description
        cell.nameProduct.text = prodArray[indexPath.row].name
   
        return cell
    }
   
    
    @IBAction func DetailProduitAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "louerViewController") as! louerViewController
   
        present(vc, animated: true, completion: nil)
    }
}
