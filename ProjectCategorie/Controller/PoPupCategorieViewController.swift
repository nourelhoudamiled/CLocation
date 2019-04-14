//
//  PoPupCategorieViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 12/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
class PoPupCategorieViewController: UIViewController {

    @IBOutlet var popUpview: UIView!
    @IBOutlet var tableView: UITableView!
    
    var CategoriesListNames = [String]()
    var CategoriList = [CategorieClass]()

    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/EnumCategories")!)
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Apply radius to Popupview
        popUpview.layer.cornerRadius = 10
        popUpview.layer.masksToBounds = true
        getCategorieNames()

    }
    
    func getCategorieNames(){
        let urlString = urlRequest.url?.absoluteString
        AF.request(urlString! , method : .get).responseJSON {
            
            response in
            
            
            
            do {
                let itemDetails1 = try JSONDecoder().decode([CategorieClass].self, from: response.data!)
                for item1 in itemDetails1 {
                    self.CategoriesListNames.append(item1.name ?? "")
                    
                    self.CategoriList.append(item1)
                }
                
                self.tableView.reloadData()
                
                
            }catch let errords {
                
                print(errords)
            }
            
        }
    }
    @IBAction func cancelPopUp(_ sender: Any) {
            dismiss(animated: true, completion: nil)
    }
    

}
extension PoPupCategorieViewController : UITableViewDelegate , UITableViewDataSource {
    // Returns count of items in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.CategoriList.count
    }
    // Select item from tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("categorie Name : " + CategoriList[indexPath.row].name!)
        
        Share.sharedName.categorieName = CategoriList[indexPath.row].name
        Share.sharedName.categorieId = CategoriList[indexPath.row].id

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AjouterProduitViewController") as! AjouterProduitViewController
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    //Assign values for tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = CategoriList[indexPath.row].name
        
        return cell
    }

}
