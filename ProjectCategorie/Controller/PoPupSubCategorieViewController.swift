//
//  PoPupSubCategorieViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 12/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
class PoPupSubCategorieViewController: UIViewController {

    @IBOutlet var viewPopOver: UIView!
    @IBOutlet var tableView: UITableView!
    var sousCategoriesListNames = [String]()
    var sousCategoriList = [SousCategClass]()
  
    var urlRequest1 = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Category/SubCategory/")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Apply radius to Popupview
        viewPopOver.layer.cornerRadius = 10
        viewPopOver.layer.masksToBounds = true
        getSubCategorieNames()

    }
    func getSubCategorieNames() {
              let id : Int = Share.sharedName.categorieId ?? 1
        let urlString1 = self.urlRequest1.url?.absoluteString
        let url = urlString1!+"\(id )"
        
        AF.request(url , method : .get).responseJSON {
            response in
            do {
  
                if let data = response.data {
                    let itemDetails1 = try JSONDecoder().decode([SousCategClass].self, from: data)
                    for item1 in itemDetails1 {
                        self.sousCategoriesListNames.append(item1.name ?? "")
                        self.sousCategoriList.append(item1)
                    }
                    
                    print("sousCategoriesListNames after append \(self.sousCategoriesListNames)")
                    
                   self.tableView.reloadData()
                }
                
                
            }catch let errords {
                
                print(errords)
            }
            
        }
        
    }
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
 

}
extension PoPupSubCategorieViewController : UITableViewDataSource , UITableViewDelegate {
    // Returns count of items in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sousCategoriList.count
    }
    // Select item from tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("sub categorie Name : " + sousCategoriList[indexPath.row].name!)
        
        Share.sharedName.subcategorieName = sousCategoriList[indexPath.row].name
      Share.sharedName.SubcategorieId = sousCategoriList[indexPath.row].id
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AjouterProduitViewController") as! AjouterProduitViewController
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    //Assign values for tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellsub", for: indexPath)
        
        cell.textLabel?.text = sousCategoriList[indexPath.row].name
        
        return cell
    }
    

}
