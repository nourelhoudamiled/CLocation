//
//  PageCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 10/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import SWCombox
import Alamofire
protocol MyCollectionViewCellDelegate: class {
    func didLongPressCell()
}
class PageCell: UICollectionViewCell {
    
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var swcomboxSub: SWComboxView!
    var delegate : MyCollectionViewCellDelegate?

    @IBOutlet var comboxCat: SWComboxView!
    @IBOutlet var steponeIamge: UIImageView!
    @IBOutlet var namecatLabel: UILabel!
    
    @IBOutlet var nameSubCatLabel: UILabel!
 
    

    func longPressAction() {
        if let del = self.delegate {
            del.didLongPressCell()
        }
    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//    }
//    // Set up ComboBoxView
//
//    func setupComboBox1(item : Float) {
//
//        comboxCat.dataSource = self
//        comboxCat.delegate = self
//        comboxCat.showMaxCount = CGFloat(item)
//        comboxCat.defaultSelectedIndex = 0//start from 0
//
//
//    }
//
//    func setupComboBox2(item : Int) {
//
//        swcomboxSub.dataSource = self
//        swcomboxSub.delegate = self
//        swcomboxSub.showMaxCount = CGFloat(item)
//        swcomboxSub.defaultSelectedIndex = 0//start from 0
//
//
//    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//
//    }
   
    

    
    /************** Post ***************/
    func postProduct() {
//        let urlString = "https://clocation.azurewebsites.net/api/Products"
//        print(" contaz.list[contaz.defaultSelectedIndex]] \( (comboxCat.list[comboxviewCat.defaultSelectedIndex] as AnyObject))")
//        AF.request(urlString, method: .post, parameters: ["name": nameTextField.text! , "description" : descriptionText.text! , "price" : priceTextField.text! , "address" : addressTextField.text! , "enumSubCategoryId" : sousCategoriList[comboxviewSubCat.defaultSelectedIndex].enumCategoryId],encoding: JSONEncoding.default, headers: nil).responseJSON {
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
//    @IBAction func addAction(_ sender: Any) {
//        postProduct()
//
//
//    }
//    func getsub() {
//        let urlString1 = self.urlRequest2.url?.absoluteString
//
//
//
//        AF.request(urlString1! , method : .get).responseJSON {
//            response in
//            do {
//                print("sousCategoriesListNames avant supp \(self.sousCategoriesListNames)")
//                self.sousCategoriesListNames.removeAll()
//
//                print("sousCategoriesListNames after supp \(self.sousCategoriesListNames)")
//                if let data = response.data {
//                    let itemDetails1 = try JSONDecoder().decode([SousCategClass].self, from: data)
//                    for item1 in itemDetails1 {
//                        self.sousCategoriesListNames.append(item1.name ?? "")
//                        self.sousCategoriList.append(item1)
//                    }
//
//                    print("sousCategoriesListNames after append \(self.sousCategoriesListNames)")
//                    self.swcomboxSub.dataSource = self
//                    self.swcomboxSub.delegate = self
//
//
//                }
//
//
//            }catch let errords {
//
//                print(errords)
//            }
//
//        }
//
//    }
//    func indexSelected(id : Int) {
//
//        let urlString1 = self.urlRequest1.url?.absoluteString
//        let url = urlString1!+"\(id )"
//
//
//        AF.request(url , method : .get).responseJSON {
//            response in
//            do {
//                print("sousCategoriesListNames avant supp \(self.sousCategoriesListNames)")
//                self.sousCategoriesListNames.removeAll()
//
//                print("sousCategoriesListNames after supp \(self.sousCategoriesListNames)")
//                if let data = response.data {
//                    let itemDetails1 = try JSONDecoder().decode([SousCategClass].self, from: data)
//                    for item1 in itemDetails1 {
//                        self.sousCategoriesListNames.append(item1.name ?? "")
//                        self.sousCategoriList.append(item1)
//                    }
//
//                    print("sousCategoriesListNames after append \(self.sousCategoriesListNames)")
//                    self.setupComboBox2(item: itemDetails1.count)
//
//
//                }
//
//
//            }catch let errords {
//
//                print(errords)
//            }
//
//        }
//
//    }
//
//
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//
//    }
//}
//// SWComboxViewDataSourcce
//extension PageCell: SWComboxViewDataSourcce {
//    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
//
//        if combox == comboxCat
//        {
//            return CategoriesListNames
//        }
//        else
//        {
//            return sousCategoriesListNames
//
//        }
//
//    }
//
//
//    func comboxSeletionView(combox: SWComboxView) -> SWComboxSelectionView {
//        return SWComboxTextSelection()
//    }
//
//    func configureComboxCell(combox: SWComboxView, cell: inout SWComboxSelectionCell) {}
//}
//
//// SWComboxViewDelegate
//extension PageCell : SWComboxViewDelegate {
//    //MARK: delegate
//    func comboxSelected(atIndex index:Int, object: Any, combox withCombox: SWComboxView) {
//        print("index - \(index) selected - \(object)")
//
//        selectedItemID =   CategoriList[comboxCat.defaultSelectedIndex].id
//        self.indexSelected(id: selectedItemID ?? 1)
//
//    }
//
//    func comboxOpened(isOpen: Bool, combox: SWComboxView) {
//        if isOpen {
//            if combox == comboxCat && swcomboxSub.isOpen {
//                swcomboxSub.onAndOffSelection()
//            }
//
//            if combox == swcomboxSub && comboxCat.isOpen {
//                swcomboxSub.onAndOffSelection()
//            }
//        }
//    }
//    
}
