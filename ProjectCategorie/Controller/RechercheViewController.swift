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
//    var image = [UIImage]()
    var sectionData = [SousCategClass]()
}
class RechercheViewController: UIViewController , UISearchBarDelegate{
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var btnMenuButton: UIBarButtonItem!
    var images = ["vehicules", "immobilier" , "Habillement et Bien Etre",  "Meubles", "Agricole" , "Pour la Maison et Jardin" , "Emploi et Services" , "Loisirs et Diverssement" , "Informatique et Multimedia" , "Autres"]
    var categorieList = [CategorieClass]()
 
    var sousCategoriesList =  [SousCategClass]()


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
                navigationItem.title = " Rechercher Produit "
            
            
            
        }
        viewTable.rowHeight = UITableView.automaticDimension
        viewTable.estimatedRowHeight = 100
         self.viewTable.register(UINib( nibName: "ChildSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "child")
//        viewTable.register(ChildSearchTableViewCell.self, forCellReuseIdentifier: "child")

       // viewTable.register(ChildSearchTableViewCell.self, forCellReuseIdentifier: "cell")

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
//    func filterListcat() { // should probably be called sort and not filter
//        categorieList.sort() { $0.id! > $1.id! } // sort the fruit by name
//        self.viewTable.reloadData() // notify the table view the data has changed
//    }
    func filterListsousCat() { // should probably be called sort and not filter
        sousCategoriesList.sort() { $0.id! > $1.id! } // sort the fruit by name
        self.viewTable.reloadData() // notify the table view the data has changed
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
                self.categorieList.removeAll()

                for categorie in categorieListJson {
                    self.categorieList.append(categorie)
                    guard let  categorieID = categorie.id else {return}
                    let subCategorieURL = urlString1! + "\(categorieID)"

                    AF.request(subCategorieURL , method : .get ).responseJSON {
                        response in
                        do {
                            if let data = response.data {
                                let subCategorieList = try JSONDecoder().decode([SousCategClass].self, from: data)
                                self.sousCategoriesList.removeAll()
                                for subCategorie in subCategorieList {
                                    self.sousCategoriesList.append(subCategorie)
                                }
                        
                                let cellData = CellData(opened: false, title: categorie.name! , sectionData: self.sousCategoriesList )
                              self.tableViewData.append(cellData)
                            self.CurrentTableViewData = self.tableViewData
                            

                                DispatchQueue.main.async {
                                    self.categorieList.sort() { $0.name! > $1.name! }
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

  func setUpSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
      
    
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
        
//        if let navigationbar = self.navigationController?.navigationBar {
//            navigationbar.barTintColor = UIColor.gray
//        }
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        
        
        
    }
  
    // Search Bar
    func alterLayout() {
        viewTable.tableHeaderView = UIView()
        // search bar in section header
        viewTable.estimatedSectionHeaderHeight = 50
        // search bar in navigation bar
     
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
 
        CurrentTableViewData = tableViewData.filter({ cat -> Bool in
           
                if searchText.isEmpty { return true }
                return cat.title.lowercased().contains(searchText.lowercased())
        
        })
        viewTable.reloadData()
    }
  
    
}

extension RechercheViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//  let cel : ChildSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChildSearchTableViewCell
     
        if indexPath.row == 0 {
        
            if CurrentTableViewData[indexPath.section].opened == true {
                CurrentTableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer : indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else {
                CurrentTableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer : indexPath.section)
                tableView.reloadSections(sections, with: .none)
                
            }
            
        }
        else {
       
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "produitParSubCatViewController") as! produitParSubCatViewController
        Share.sharedName.sousCategorie =  CurrentTableViewData[indexPath.section].sectionData[indexPath.row - 1]
            present(vc, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
//        cell.accessoryType = .none

        if indexPath.row == 0 {
         

            cell.nameCategorie.text  = CurrentTableViewData[indexPath.section].title
            cell.imageCat.image = UIImage(named: images[indexPath.section])
                cell.imageCat.isHidden = false
            cell.imageCat.layer.cornerRadius = 20.0
            cell.viewCell.layer.cornerRadius = 10

            cell.viewCell.layer.shadowColor = UIColor.black.cgColor
            cell.viewCell.layer.shadowOpacity = 1
            cell.viewCell.layer.shadowOffset = CGSize.zero
            cell.viewCell.layer.shadowRadius = 10
            cell.selectionStyle = .none
            
//            cell.accessoryType = .none
            

            return cell
        }
        else
        {
            let cel : ChildSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "child") as! ChildSearchTableViewCell
//            cel.animate()
//            print("cell name \(cel.label.text)")
            cel.label.text = CurrentTableViewData[indexPath.section].sectionData[indexPath.row - 1 ].name!
           // cel.setCellContent(text: )
            
            cel.view.layer.shadowColor = UIColor.black.cgColor
            cel.view.layer.shadowOpacity = 1
//            cel.view.layer.shadowOffset = CGSize.zero
//            cel.view.layer.shadowRadius = 10
             tableView.deleteRows(at: [indexPath], with: .automatic)
              cel.selectionStyle = .none
            return cel
            
            
            
        }

        
        
        
    }
    
}


