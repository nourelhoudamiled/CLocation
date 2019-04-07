//
//  AjouterProduitViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 29/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

import Alamofire

import SWCombox

class AjouterProduitViewController: UIViewController {
    
    @IBOutlet var minDuréLabel: UITextField!


  
    @IBOutlet var descriptionText: UITextField!
    
 
    @IBOutlet var comboxviewCat: SWComboxView!
    
    @IBOutlet var comboxviewSubCat: SWComboxView!
    
    @IBOutlet var addressTextField: UITextField!
    

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var availbleSwith: UISwitch!
    
    @IBOutlet var priceTextField: UITextField!
    
    
    var sousCategoriesListNames = [String]()
    var CategoriesListNames = [String]()
    var selectedItemID : Int?
    
    var sousCategoriList = [SousCategClass]()
    var CategoriList = [CategorieClass]()
    var urlRequest1 = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Category/SubCategory/")!)
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/EnumCategories")!)
     var urlRequest2 = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/EnumSubCategories")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            
            
            
        }
        getCategorieNames()
       // getsub()
        
        // getSousCategorieNames()
        
        // Do any additional setup after loading the view.
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
                self.setupComboBox1(item: Float(itemDetails1.count))
                
                
                
                
            }catch let errords {
                
                print(errords)
            }
            
        }
    }
    
    // Set up ComboBoxView

    func setupComboBox1(item : Float) {
     
        comboxviewCat.dataSource = self
        comboxviewCat.delegate = self
        comboxviewCat.showMaxCount = CGFloat(item)
        comboxviewCat.defaultSelectedIndex = 0//start from 0
        
        
    }
    func setupComboBoxVide() {
        comboxviewSubCat.dataSource = self
        comboxviewSubCat.delegate = self
        comboxviewCat.dataSource = self
        comboxviewCat.delegate = self
        
        comboxviewCat.defaultSelectedIndex = 1//start from 0
        
        
    }
    func setupComboBox2(item : Int) {
      
        self.comboxviewSubCat.dataSource = self
        self.comboxviewSubCat.delegate = self
        comboxviewSubCat.showMaxCount = CGFloat(item)
        comboxviewSubCat.defaultSelectedIndex = 0//start from 0
        
        
    }
    
    /************** Post ***************/
    func postProduct() {
        let urlString = "https://clocation.azurewebsites.net/api/Products"
        print(" contaz.list[contaz.defaultSelectedIndex]] \( (comboxviewCat.list[comboxviewCat.defaultSelectedIndex] as AnyObject))")
                AF.request(urlString, method: .post, parameters: ["name": nameTextField.text! , "description" : descriptionText.text! , "price" : priceTextField.text! , "address" : addressTextField.text! , "enumSubCategoryId" : sousCategoriList[comboxviewSubCat.defaultSelectedIndex].enumCategoryId],encoding: JSONEncoding.default, headers: nil).responseJSON {
                    response in
        
                    switch response.result {
                    case .success:
                        print(response)
        
                        break
                    case .failure(let error):
        
                        print(error)
                    }
                }
    }
    
    //
    @IBAction func addAction(_ sender: Any) {
        postProduct()
        
        
    }
    func getsub() {
        let urlString1 = self.urlRequest2.url?.absoluteString
      
        
        
        AF.request(urlString1! , method : .get).responseJSON {
            response in
            do {
                print("sousCategoriesListNames avant supp \(self.sousCategoriesListNames)")
                self.sousCategoriesListNames.removeAll()
                
                print("sousCategoriesListNames after supp \(self.sousCategoriesListNames)")
                if let data = response.data {
                    let itemDetails1 = try JSONDecoder().decode([SousCategClass].self, from: data)
                    for item1 in itemDetails1 {
                        self.sousCategoriesListNames.append(item1.name ?? "")
                        self.sousCategoriList.append(item1)
                    }
                    
                    print("sousCategoriesListNames after append \(self.sousCategoriesListNames)")
                    self.comboxviewSubCat.dataSource = self
                    self.comboxviewSubCat.delegate = self
                    
                    
                }
                
                
            }catch let errords {
                
                print(errords)
            }
            
        }
        
    }
    func indexSelected(id : Int) {
        
        let urlString1 = self.urlRequest1.url?.absoluteString
        let url = urlString1!+"\(id )"
        
      
        AF.request(url , method : .get).responseJSON {
            response in
            do {
                print("sousCategoriesListNames avant supp \(self.sousCategoriesListNames)")
                self.sousCategoriesListNames.removeAll()
             
                print("sousCategoriesListNames after supp \(self.sousCategoriesListNames)")
                if let data = response.data {
                    let itemDetails1 = try JSONDecoder().decode([SousCategClass].self, from: data)
                    for item1 in itemDetails1 {
                        self.sousCategoriesListNames.append(item1.name ?? "")
                        self.sousCategoriList.append(item1)
                    }
                    
                    print("sousCategoriesListNames after append \(self.sousCategoriesListNames)")
                    self.setupComboBox2(item: itemDetails1.count)
              
                    
                }
                
                
            }catch let errords {
                
                print(errords)
            }
            
        }
        
    }
    
    
    
}
// SWComboxViewDataSourcce
extension AjouterProduitViewController: SWComboxViewDataSourcce {
    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
        
        if combox == comboxviewCat
        {
            return CategoriesListNames
        }
        else
        {
            return sousCategoriesListNames
            
        }
        
    }
    
    
    func comboxSeletionView(combox: SWComboxView) -> SWComboxSelectionView {
        return SWComboxTextSelection()
    }
    
    func configureComboxCell(combox: SWComboxView, cell: inout SWComboxSelectionCell) {}
}

// SWComboxViewDelegate
extension AjouterProduitViewController : SWComboxViewDelegate {
    //MARK: delegate
    func comboxSelected(atIndex index:Int, object: Any, combox withCombox: SWComboxView) {
        print("index - \(index) selected - \(object)")
        
        selectedItemID =   CategoriList[comboxviewCat.defaultSelectedIndex].id
        self.indexSelected(id: selectedItemID ?? 1)
        
    }
    
    func comboxOpened(isOpen: Bool, combox: SWComboxView) {
        if isOpen {
            if combox == comboxviewCat && comboxviewSubCat.isOpen {
                comboxviewSubCat.onAndOffSelection()
            }
            
            if combox == comboxviewSubCat && comboxviewCat.isOpen {
                comboxviewSubCat.onAndOffSelection()
            }
        }
    }
    
}
