//
//  ViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 08/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

struct CellData  {
    var opened = Bool()
    var title =  String()
//    var image = [UIImage]()
    var sectionData = [SousCategClass]()
}
class RechercheViewController: UIViewController , UISearchBarDelegate  {
    //var locationManager: CLLocationManager!

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var locationManager: LocationManager?

    
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
    
        let userDictionnary = UserDefaults.standard.dictionary(forKey: "userDictionnary")
        print(userDictionnary?["name"])
        print("Token ViewCont ViewDidAppear = \(UserDefaults.standard.string(forKey: "Token"))")

        UITabBar.appearance().barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

     

        
        self.locationManager?.getlocationForUser { (userLocation: CLLocation) -> () in
            print(userLocation)
        }
         self.viewTable.register(UINib( nibName: "ChildSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "child")
//        viewTable.register(ChildSearchTableViewCell.self, forCellReuseIdentifier: "child")

       // viewTable.register(ChildSearchTableViewCell.self, forCellReuseIdentifier: "cell")

        activityIndicator.startAnimating()
 
        dataCatégorie()

    }
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation:CLLocation = locations[0]
//        let long = userLocation.coordinate.longitude;
//        let lat = userLocation.coordinate.latitude;
//
//        print(long, lat)
//
//        //Do What ever you want with it
//    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setUpSearchBar()

        if (isLoggedIn()) {
            print("c'est deja connecte \( AppManager.shared.iduser)")
            print("user is  \( AppManager.shared.user)")
         
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
self.viewTable.reloadData()
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
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                            }
                        }catch {
                            //
                        }
                        
                    }
                  
                }

    }catch let error {
                print(error)
            }
           
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
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
                navigationController?.navigationController?.navigationItem.leftBarButtonItem = nil

            }
        }
   

        
//        if let navigationbar = self.navigationController?.navigationBar {
//            navigationbar.barTintColor = UIColor.gray
//        }
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        
        
        
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.navigationController?.isNavigationBarHidden = false

    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationController?.navigationController?.isNavigationBarHidden = true

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
    
   
    
//    scrollViewDidScroll
   
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
            self.viewTable.reloadData()

            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)

            self.navigationController?.pushViewController(vc, animated: true)

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
           print("cell name \( CurrentTableViewData[indexPath.section].sectionData[indexPath.row - 1 ].id)")
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


