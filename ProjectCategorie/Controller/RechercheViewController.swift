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
    
    @IBOutlet var btnMenuButton: UIBarButtonItem!
    
    var categorieList = [CategorieClass]()
    var CURENTcatArray = [CategorieClass]()
    
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/EnumCategories")!)
    var urlRequest1 = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Category/SubCategory/")!)
    var CategoriesListNames = [String]()
    var sousCategoriesListNames = [String]()
    var tableViewData = [CellData]()
      var CurrentTableViewData = [CellData]()
    @IBOutlet var viewTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Token ViewCont ViewDidAppear = \(UserDefaults.standard.string(forKey: "Token"))")

        if revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            
            
            
        }
        dataCatégorie()
        setUpSearchBar()
//        alterLayout()
        activityIndicator.startAnimating()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if (isLoggedIn()) {
            print("c'est deja connecte")
            
            
        }
        
        
    }
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    func dataCatégorie(){
        print("Token ViewCont PressedButton = \( AppManager.shared.token)")
        let urlString = urlRequest.url?.absoluteString
        let urlString1 = urlRequest1.url?.absoluteString
        AF.request(urlString!).responseJSON {
            response in
            do {
                guard let data = response.data else {return}
                let categorieListJson = try JSONDecoder().decode([CategorieClass].self, from: data)
                for categorie in categorieListJson {
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
                            self.CurrentTableViewData = self.tableViewData
   
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
            viewTable.reloadData()
            return }
     CurrentTableViewData  =  tableViewData.filter({ cat -> Bool in
            guard let text = searchBar.text else {return false}
            return (cat.title.contains(text))
            
        })
        viewTable.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
}

extension RechercheViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            if CurrentTableViewData[indexPath.section].opened == true {
                CurrentTableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer : indexPath.section)
                tableView.reloadSections(sections, with: .none)
            
                
            }
            else {
                CurrentTableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer : indexPath.section)
                tableView.reloadSections(sections, with: .fade)
                
            }
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            vc.subCategorie =  CurrentTableViewData[indexPath.section].sectionData[indexPath.row - 1]
            present(vc, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CurrentTableViewData[section].opened == true
        {
            return CurrentTableViewData[section].sectionData.count + 1
            
        }else {
            return 1
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CurrentTableViewData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SearchViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchViewCell
        cell.accessoryType = .disclosureIndicator
        if indexPath.row == 0 {
            cell.nameCategorie.text  = CurrentTableViewData[indexPath.section].title
       
            return cell
        }
        else
        {
            
            cell.nameCategorie.text = CurrentTableViewData[indexPath.section].sectionData[indexPath.row - 1 ].name
            tableView.deleteRows(at: [indexPath], with: .fade)
            cell.accessoryType = .none
            
            return cell
            
            
            
        }
        
        
        
    }
    
}


