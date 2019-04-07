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
        
        
    }
    
    @IBAction func gotoLouerButton(_ sender: Any) {
        
    }
    func ExpandItemsApi() {
        
        let urlString = urlRequest.url?.absoluteString
        guard let subCategorieID = subCategorie?.id else {
            return
        }
        let productURL = urlString! + "\(subCategorieID)"
        
        AF.request(productURL , method : .get).responseJSON {
            response in
            do {
                
                let itemDetails = try JSONDecoder().decode([ProductClass].self, from: response.data!)
                
                for item in itemDetails {
                    self.ProductList.append(item)
                    //                    self.catArray.append(CategorieClass(name: item.name!))
                    
                }
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
        return ProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : productTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! productTableViewCell
        cell.descrpitionLabel.text = ProductList[indexPath.row].description
        cell.nameProduct.text = ProductList[indexPath.row].name
        
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
                let Request = try decoder.decode(Unite.self, from: data)
                print(Request)
                print(Request.id!)
            } catch let error {
                print(error)
                completion(nil)
            }
        }
    }
}
