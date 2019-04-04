//
//  ViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 08/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
struct CellData  {
    var opened = Bool()
    var title =  String()
    var sectionData = [SousCategClass]()
}
class RechercheViewController: UIViewController , UISearchBarDelegate{
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var searchBar: UISearchBar!
    
   
    var categorieList = [CategorieClass]()
    var CURENTcatArray = [CategorieClass]()
    
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/EnumCategories")!)
    var urlRequest1 = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Category/SubCategory/")!)
    var CategoriesListNames = [String]()
    var sousCategoriesListNames = [String]()
    var tableViewData = [CellData]()
    
    @IBOutlet var viewTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataCatégorie()
        setUpSearchBar()
        alterLayout()
        activityIndicator.startAnimating()
    }
    func dataCatégorie(){
        
        let urlString = urlRequest.url?.absoluteString
        let urlString1 = urlRequest1.url?.absoluteString
        
        AF.request(urlString!).responseJSON {
            response in
            do {
                guard let data = response.data else {return}
                let categorieList = try JSONDecoder().decode([CategorieClass].self, from: data)
                
                for categorie in categorieList {
                    self.categorieList.append(categorie)
                    guard let  categorieID = categorie.id else {return}
                    let subCategorieURL = urlString1! + "\(categorieID)"
                    AF.request(subCategorieURL , method : .get ).responseJSON {
                        response in
                        do {
                            var sousCategoriesList =  [SousCategClass]()
                            if let data = response.data {
                                let subCategorieList = try JSONDecoder().decode([SousCategClass].self, from: data)
                                for subCategorie in subCategorieList {
                                    sousCategoriesList.append(subCategorie)
                                }
                                let cellData = CellData(opened: false, title: categorie.name!, sectionData: sousCategoriesList)
                                self.tableViewData.append(cellData)
                                DispatchQueue.main.async {
                                    self.viewTable.reloadData()
                                }
                            }
                        }catch {
                            //
                        }
                    }
                }
                
    }catch let error {
                print(error)
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        
        
    }
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
  
    // Search Bar
    func alterLayout() {
        viewTable.tableHeaderView = UIView()
        // search bar in section header
        viewTable.estimatedSectionHeaderHeight = 50
        // search bar in navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false // you can show/hide this dependant on your layout
        searchBar.placeholder = "Search catégorie by Name"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            CURENTcatArray = categorieList
            viewTable.reloadData()
            return }
        CURENTcatArray = categorieList.filter({ cat -> Bool in
            guard let text = searchBar.text else {return false}
            return (cat.name!.contains(text))
            
        })
        viewTable.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
}

extension RechercheViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer : indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer : indexPath.section)
                tableView.reloadSections(sections, with: .fade)
                
            }
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            vc.subCategorie =  tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            present(vc, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true
        {
            return tableViewData[section].sectionData.count + 1
            
        }else {
            return 1
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SearchViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchViewCell
        
        if indexPath.row == 0 {
            cell.nameCategorie.text  = tableViewData[indexPath.section].title
       
            return cell
        }
        else
        {
            
            cell.nameCategorie.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1 ].name
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            return cell
            
            
            
        }
        
        
        
    }
    
}


