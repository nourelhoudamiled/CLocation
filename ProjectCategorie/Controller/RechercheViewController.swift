//
//  ViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 08/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
struct cellData  {
    var opened = Bool()
    var title =  String()
    var sectionData = [SousCategClass]()
}
class RechercheViewController: UIViewController , UITableViewDelegate , UITableViewDataSource  , UISearchBarDelegate{
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var searchBar: UISearchBar!
    var catArray = [CategorieClass]()
    var CURENTcatArray = [CategorieClass]()
     var sousCategoriesList = [SousCategClass]()
    var curentList = [SousCategClass]()
    
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/EnumCategories")!)
    var urlRequest1 = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Category/SubCategory/")!)
//    var urlRequest1 = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/EnumSubCategories/")!)
    
    var tableViewData = [cellData]()
    
    @IBOutlet var viewTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataCatégorie()
        //      ExpandItemsApi()
        setUpSearchBar()
        alterLayout()
        //viewTable.tableFooterView = UIView()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        activityIndicator.startAnimating()
    }
    func dataCatégorie(){
        
        let urlString = urlRequest.url?.absoluteString
        let urlString1 = urlRequest1.url?.absoluteString
        
        AF.request(urlString!).responseJSON {
            response in
            do {
                // print(response.result.value!)
                let itemDetails = try JSONDecoder().decode([CategorieClass].self, from: response.data!)
                
                for item in itemDetails {
                  print(item.id!)
                    guard let ids = item.id else {return}
                    AF.request(urlString1!+("\(ids)")
                        , method : .get ).responseJSON {
                        response in
                        do {
                            let itemDetails1 = try JSONDecoder().decode([SousCategClass].self, from: response.data!)
                            
                            for item1 in itemDetails1 {
                                self.sousCategoriesList.append(item1)
                               
                            }
                            
                            print(itemDetails1)
                            print(itemDetails)
                            self.curentList = self.sousCategoriesList
                            self.tableViewData.append(  cellData(opened: false, title:  item.name!, sectionData: self.curentList))
                            
                              DispatchQueue.main.async {
                            self.viewTable.reloadData()
                            }
                            
                        }catch let errords {
                            
                            print(errords)
                        }
                    }
                }
                  DispatchQueue.main.async {
                  self.viewTable.reloadData()
                }
            }catch let errors {
                
                print(errors)
            }
            
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            
        }
        
        
    }
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
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
        { if indexPath.row == 1 {
            tableViewData[indexPath.row].opened = false
            }
            //use different cell identifier if needed
            
            cell.nameCategorie.text = tableViewData[indexPath.row].sectionData[indexPath.row - 1].name
            
            
            return cell
            
            
        }
        
        
        
    }
    
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            CURENTcatArray = catArray
            viewTable.reloadData()
            return }
        CURENTcatArray = catArray.filter({ cat -> Bool in
            guard let text = searchBar.text else {return false}
            return (cat.name!.contains(text))
            
        })
        viewTable.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
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
                tableView.reloadSections(sections, with: .none)
                
            }
        }else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            vc.subCategorie =  tableViewData[indexPath.row].sectionData[indexPath.row - 1]
            present(vc, animated: true, completion: nil)
        }
    }
    
}




