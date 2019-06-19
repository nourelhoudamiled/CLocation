//
//  TestViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 04/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import RSSelectionMenu
import DJSemiModalViewController
import Alamofire
struct expendCategory  {
    var title =  String()
    var productList = [ProductClass]()
    var images = [UIImage]()
    
}
struct CellD  {
    
    var produits =  [ProductClass]()
    //    var image = [UIImage]()
    var images = [UIImage]()
    var ratings =  [String]()
    var title = String()
}
class HomeController: UIViewController , UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    let urlSearchRating = "http://clocation.azurewebsites.net/api/Search/Product/Rating/"
    var urlImageByAttachmentId =  "http://clocation.azurewebsites.net/api/Attachments/"
    var urlProduct = "http://clocation.azurewebsites.net/api/Products"
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/EnumCategories")!)
    var urlRequest1 = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Category/Product/")!)
    
    @IBOutlet var collectionView: UICollectionView!
    var categorieList = [CategorieClass]()
    var ratingNotes = [String]()
    var productImages = [UIImage]()
    var productList = [ProductClass]()
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var RegionListNames = [String]()
    var selectedDataArray = [String]()
    var cellSelectionStyle: CellSelectionStyle = .tickmark
    var RegionList = [RegionClass]()
    var idRegion = Int()
    var tableViewData = [expendCategory]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // getAllProduit()
        dataCatégorie()
        
        setUpSearchBar()
        getRegionNames()
        self.tableView.register(UINib( nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        self.tableView.register(UINib( nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        //        self.collectionView.register(UINib( nibName: "produitCell", bundle: nil), forCellWithReuseIdentifier: "produitCell")
        //        self.collectionView.register(UINib( nibName: "CollectionTitleCell", bundle: nil), forCellWithReuseIdentifier: "CollectionTitleCell")
        activityIndicator.startAnimating()
        tableView.rowHeight = 315
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func searchIdRegionByProduit(){
        var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Region/Product/")!)
        let urlString = urlRequest.url?.absoluteString
        
        self.productList.removeAll()
        //        self.responseImages.removeAll()
        let url = urlString! + "\(idRegion)"
        AF.request(url , method : .get).responseJSON {
            
            response in
            do {
                if let data = response.data {
                    let itemDetails1 = try JSONDecoder().decode([ProductClass].self, from: data)
                    for item1 in itemDetails1 {
                        self.productList.append(item1)
                        guard let productId = item1.id else {return}
                        self.searchRating(productId: productId)
                        
                    }
                    self.tableView.reloadData()
                    
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }catch let errords {
                print(errords)
            }
        }
        
    }
    
    func getRegionNames(){
        var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/EnumRegion")!)
        
        let urlString = urlRequest.url?.absoluteString
        AF.request(urlString! , method : .get).responseJSON {
            
            response in
            do {
                if let data = response.data {
                    let itemDetails1 = try JSONDecoder().decode([RegionClass].self, from: data)
                    for item1 in itemDetails1 {
                        self.RegionListNames.append(item1.name ?? "")
                        self.RegionList.append(item1)
                        
                    }
                    print(self.RegionList)
                }
            }catch let errords {
                
                print(errords)
            }
            
        }
    }
    @objc func searchByRegion() {
        print("name")
        let menu = RSSelectionMenu(selectionStyle: .single, dataSource: RegionListNames) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            print("index \(indexPath )")
            
            print("name \(name)")
            
            // cell customization
            // set tint color
            cell.tintColor = UIColor.orange
        }
        
        // provide - selected items and selection delegate
        
        menu.setSelectedItems(items: selectedDataArray) { [weak self] (name, index, selected, selectedItems) in
            self?.selectedDataArray = selectedItems
            self?.idRegion = index + 1
            
            /// do some stuff...
            
            //self?.formsheetDetailLabel.text = name
            print("name \(name)")
            print("index \(index )")
            // self?.label.text = name
            self?.activityIndicator.startAnimating()
            
            self?.searchIdRegionByProduit()
            
        }
        
        // show with search bar
        
        menu.showSearchBar { [weak self] (searchText) -> ([String]) in
            
            // Filter your result from data source based on any condition
            // Here data is filtered by name that starts with the search text
            
            return self?.RegionListNames.filter({ $0.lowercased().starts(with: searchText.lowercased()) }) ?? []
        }
        
        // cell selection style
        menu.cellSelectionStyle = self.cellSelectionStyle
        
        // show empty data label - if needed
        // Note: Default text is 'No data found'
        
        menu.showEmptyDataLabel()
        
        // show as formsheet
        menu.show(style: .formSheet, from: self)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.navigationController?.isNavigationBarHidden = false
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationController?.navigationController?.isNavigationBarHidden = true
        
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("click")
        searchByRegion()
    }
    func setUpSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        
        //        searchBar.delegate = self
        
        let scb = searchController.searchBar
        scb.showsBookmarkButton = true
        
        scb.setImage(UIImage(named: "adress"), for: UISearchBar.Icon.bookmark, state: .normal)
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
    
    
    func searchRating (productId : Int) {
        let SearchRatingURL = urlSearchRating + "\(productId)"
        
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
            //self.tableView.reloadData()
            
            // self.searchImage()
            
        }
    }
//    func searchImage(productId : Int) {
//        var urlRequestImageByAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
//        let urlStringImageByAttachmentId = urlRequestImageByAttachmentId.url?.absoluteString
//        let attachementURL = urlStringImageByAttachmentId! + "\(productId)/ImageByProductId"
//
//        AF.request(attachementURL , method : .get ).responseImage {
//            response in
//            guard let image = response.data else {return}
//            print(image)
//            self.productImages.append( UIImage(data: image) ?? UIImage(named: "EmmaStone")!)
//            //self.collectionView.reloadData()
//
//        }
//    }
    func searchImage(withIndex : Int) {
        var images = [UIImage]()
        //self.tableViewData[withIndex].images.removeAll()
        for product in self.tableViewData[withIndex].productList {

            let attachementURL = urlImageByAttachmentId + "\(product.id!)/ImageByProductId"

            AF.request(attachementURL , method : .get ).responseImage {
                response in
                guard let image = response.data else {return}

              
                images.append( UIImage(data: image) ?? UIImage(named: "Agricole")!)

                self.tableViewData[withIndex].images = images

                self.tableView.reloadData()

            }

        }

//        self.productImages.removeAll()
    }
    func dataCatégorie(){
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
                                self.productList.removeAll()
                                let proList = try JSONDecoder().decode([ProductClass].self, from: data)
                                for prod in proList {
                                    self.productList.append(prod)
                                  //  guard let  productid = prod.id else {return}
                                    // self.searchRating(productId: productid)
                                   // self.searchImage(productId: productid)
                                }
                                let cellData = expendCategory(title: categorie.name!, productList: self.productList , images: [UIImage]())
                                self.tableViewData.append(cellData)
                              
                                    self.searchImage(withIndex : self.tableViewData.count - 1 )
                            
                                
                                
                                
                                    self.categorieList.sort() { $0.name! > $1.name! }
                                   // self.tableView.reloadData()
                             
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
    func getAllProduit() {
        AF.request(urlProduct, method : .get).responseJSON {
            response in
            
            do {
                self.productList.removeAll()
                print("response \(response)")
                guard let data = response.data else {return}
                let itemDetails = try JSONDecoder().decode([ProductClass].self, from: data)
                print("item detaile \(itemDetails)")
                
                for item  in itemDetails {
                    self.productList.append(item)
                    guard let productId = item.id else {return}
                    //self.searchImage(productId: productId)
                    
                    self.searchRating(productId: productId)
                    
                }
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
                
            }catch let errors {
                print(errors)
            }
            
        }
        
    }
    
    
}
//extension HomeController : UICollectionViewDelegate , UICollectionViewDataSource {
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        if indexPath.row == 0 {
////
////            if tableViewData[indexPath.section].opened == true {
////                tableViewData[indexPath.section].opened = false
////                let sections = IndexSet.init(integer : indexPath.section)
////                collectionView.reloadSections(sections)
////            }
////            else {
////                tableViewData[indexPath.section].opened = true
////                let sections = IndexSet.init(integer : indexPath.section)
////                collectionView.reloadSections(sections)
////
////            }
////
////        }
////    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if tableViewData[section].opened == true
//        {
//            return tableViewData[section].sectionData.count + 1
//
//        }else {
//            return 1
//        }
// 
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.row == 0  {
//            return CGSize(width: 320, height: 50)
//        }
//        else  {
//
//            return CGSize(width: 350, height: 321)
//        }
//
//    }
//    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
//        let size = CGSize(width: 200, height: 1000)
//        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
//        return NSString(string: text).boundingRect(with: size, options: options, attributes :[NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)] , context : nil)
//
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return tableViewData.count
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        //        cell.accessoryType = .none
//
//        if indexPath.row == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionTitleCell", for: indexPath) as! CollectionTitleCell
//            cell.labelTitle.text  = tableViewData[indexPath.section].title
//            return cell
//        }
//        else
//        {
//            let cel  = collectionView.dequeueReusableCell(withReuseIdentifier: "produitCell", for: indexPath) as! produitCell
//
//            let index = indexPath.row
//            if productList.count > 0 {
//                cel.labelName.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1 ].name
//
//                cel.prixLabel.text = "\(tableViewData[indexPath.section].sectionData[indexPath.row - 1 ].price ?? 0 ) $"
//            }
////            if productImages.count > indexPath.row {
////                cel.imageproduit.image = productImages[index]
////            }
////            if ratingNotes.count > indexPath.row  {
////                cel.cosmosView.rating = Double(ratingNotes[index]) as? Double ?? 0
////            }
//            return  cel
//
//
//        }
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionTitleCell", for: indexPath) as! CollectionTitleCell
////                    cell.labelTitle.text  = tableViewData[indexPath.section].title
////                    return cell
//    }
//}
extension HomeController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //            return tableViewData[section].sectionData.count + 1
        return 2
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        }
        else {
            return 380
            
        }    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
        cell.titleLabel.text = tableViewData[indexPath.section].title
        cell.layer.backgroundColor = UIColor.white.cgColor
    
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1.0
 
        return cell
    }else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.collectionView.reloadData()
        cell.productList = tableViewData[indexPath.section].productList
        cell.productImages = tableViewData[indexPath.section].images
        cell.setUpView()
        //                        let index = indexPath.row
        //                            cell.nameProduit.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1 ].name
        //
        //                            cell.prixLabel.text = "\(tableViewData[indexPath.section].sectionData[indexPath.row - 1 ].price ?? 0 ) $"
        //            if productImages.count > indexPath.row {
        //                cel.imageproduit.image = productImages[index]
        //            }
        //            if ratingNotes.count > indexPath.row  {
        //                cel.cosmosView.rating = Double(ratingNotes[index]) as? Double ?? 0
        //            }
        cell.selectionStyle = .none
        
        return cell
        }
    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //
    //        print("\(productList[indexPath.row]) is selected")
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "louerViewController") as! louerViewController
    //        vc.product = productList[indexPath.row]
    //        Share.sharedName.product = productList[indexPath.row]
    //       // navigationController?.hidesBarsOnTap = true
    //
    //
    //       self.navigationController?.pushViewController(vc, animated: true)
    ////        present(vc, animated: true, completion: nil)
    //
    //    }
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //
    //        CurrentproduitList = tablecell.filter({ cat -> Bool in
    //
    //            if searchText.isEmpty { return true }
    //            return cat.title.lowercased().contains(searchText.lowercased())
    //
    //        })
    //        tableView.reloadData()
    //    }
    
    
    
}

