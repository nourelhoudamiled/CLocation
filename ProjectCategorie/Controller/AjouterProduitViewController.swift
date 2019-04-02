//
//  AjouterProduitViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 29/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

import Alamofire
class AjouterProduitViewController: UIViewController {
    
    

    @IBOutlet var minDuréLabel: UITextField!
    
    @IBOutlet var comboxViewCity: SWComboxView!
    @IBOutlet var comboxViewRegion: SWComboxView!
    @IBOutlet var descriptionText: UITextField!
    
    @IBOutlet var comboxView1: SWComboxView!
    
    @IBOutlet var comboxView2: SWComboxView!
    
    @IBOutlet var addressTextField: UITextField!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var availbleSwith: UISwitch!
    
    @IBOutlet var priceTextField: UITextField!
    var sousCategoriesListNames = [String]()
     var CategoriesListNames = [String]()
    var aa : Int?

    var sousCategoriList = [SousCategClass]()
       var CategoriList = [CategorieClass]()
    var urlRequest1 = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Category/SubCategory/")!)
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/EnumCategories")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        
          getCategorieNames()
      
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
//                    print(self.sousCategoriList[self.comboxView.defaultSelectedIndex].enumCategoryId)

                }
               
                self.setupComboBox1(item: Float(itemDetails1.count))
               

            }catch let errords {
                
                print(errords)
            }
            
        }
    }
    
    func getSousCategorieNames(){
     // let e = CategoriList[comboxView1.defaultSelectedIndex]
      //  print(e)
//
//        let urlString1 = urlRequest1.url?.absoluteString
//        let url = urlString1!+"\(e.id)"
//        AF.request(url , method : .get).responseJSON {
//            response in
//            do {
//                let itemDetails1 = try JSONDecoder().decode([SousCategClass].self, from: response.data!)
//                for item1 in itemDetails1 {
//                    self.sousCategoriesListNames.append(item1.name ?? "")
//                    self.sousCategoriList.append(item1)
//                }
//
//                self.setupComboBox2(item: CGFloat(itemDetails1.count))
//
//
//            }catch let errords {
//
//                print(errords)
//            }
//
//        }
    }
    // Set up ComboBoxView
    func setupComboBox1(item : Float) {
        
        comboxView1.dataSource = self
        comboxView1.delegate = self
        comboxView1.showMaxCount = CGFloat(item)
        comboxView1.defaultSelectedIndex = 0//start from 0
        

    }
    func setupComboBoxVide() {
        
        comboxView1.dataSource = self
        comboxView1.delegate = self
      
        comboxView1.defaultSelectedIndex = 0//start from 0
        
        
    }
    func setupComboBox2(item : CGFloat) {
        
        comboxView2.dataSource = self
        comboxView2.delegate = self
        comboxView2.showMaxCount = item
        comboxView2.defaultSelectedIndex = 0//start from 0
        
       
    }
    
    /************** Post ***************/
    func postProduct() {
        let urlString = "https://clocation.azurewebsites.net/api/Products"
        print(" contaz.list[contaz.defaultSelectedIndex]] \( (comboxView1.list[comboxView1.defaultSelectedIndex] as AnyObject))")
//        AF.request(urlString, method: .post, parameters: ["name": nameTextField.text! , "description" : descriptionText.text! , "price" : priceTextField.text! , "address" : addressTextField.text! , "enumSubCategoryId" : sousCategoriList[comboxView2.defaultSelectedIndex].enumCategoryId],encoding: JSONEncoding.default, headers: nil).responseJSON {
//            response in
//
//            switch response.result {
//            case .success:
//                print(response)
//
//                break
//            case .failure(let error):
//
//                print(error)
//            }
//        }
    }
    
    //
    @IBAction func addAction(_ sender: Any) {
       postProduct()
        
        
    }
   
    
    
}
// SWComboxViewDataSourcce
extension AjouterProduitViewController: SWComboxViewDataSourcce {
    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
      
        if combox == comboxView1
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
        aa = object as? Int
      aa =   CategoriList[comboxView1.defaultSelectedIndex].id
        print(aa!)
        print(object)
   

//
//            let e = CategoriList[comboxView1.defaultSelectedIndex].id!

            let urlString1 = self.urlRequest1.url?.absoluteString
        let url = urlString1!+"\(aa ?? 1)"
            AF.request(url , method : .get).responseJSON {
                response in
                do {
                    let itemDetails1 = try JSONDecoder().decode([SousCategClass].self, from: response.data!)
                    for item1 in itemDetails1 {
                        self.sousCategoriesListNames.append(item1.name ?? "")
                        self.sousCategoriList.append(item1)


                    }


                    self.setupComboBox2(item: CGFloat(itemDetails1.count))


                }catch let errords {

                    print(errords)
                }

            }
        
      

        
        
    }
    
    func comboxOpened(isOpen: Bool, combox: SWComboxView) {
        if isOpen {
            if combox == comboxView1 && comboxView2.isOpen {
                comboxView2.onAndOffSelection()
            }
            
            if combox == comboxView2 && comboxView1.isOpen {
                comboxView2.onAndOffSelection()
            }
        }
    }
}
