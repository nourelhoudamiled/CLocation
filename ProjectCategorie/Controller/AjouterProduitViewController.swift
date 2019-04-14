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
import StepIndicator
class AjouterProduitViewController: UIViewController {
    
    @IBOutlet var doneLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nombreAlLabel: UILabel!
    @IBOutlet var btnSelectAdresse: UIButton!
    // make sure you apply the correct encapsulation principles in your classes
    @IBOutlet var nextButton: UIButton!

    @IBOutlet var btnSelectCity: UIButton!
    
    @IBOutlet var ajouterProduit: UIButton!
    @IBOutlet var btnSelectRegion: UIButton!
    @IBOutlet var step4View: UIView!
    @IBOutlet var btnSelectSubCar: UIButton!
    @IBOutlet var btnSelected: UIButton!
    @IBOutlet var stepIndicatorView: StepIndicatorView!
    @IBOutlet var step3View: UIView!
    @IBOutlet var step1View: UIView!
    
    @IBOutlet var step2View: UIView!
    
    @IBOutlet var minDuréLabel: UITextField!

    @IBOutlet var descriptionText: UITextField!

    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var availbleSwith: UISwitch!
    let imagePickerController = UIImagePickerController()
    var imgArr: [UIImage?] = []
    @IBOutlet var priceTextField: UITextField!

    var amount : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

          initScrollView()
           imagePickerController.delegate = self
        if revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            
        
            
        }
   
single()
      
    }
    func  single() {
    btnSelectAdresse.backgroundColor = .clear
    btnSelectAdresse.layer.cornerRadius = 5
    btnSelectAdresse.layer.borderWidth = 0.5
    btnSelectAdresse.layer.borderColor = UIColor.lightGray.cgColor
    btnSelected.backgroundColor = .clear
    btnSelected.layer.cornerRadius = 5
    btnSelected.layer.borderWidth = 0.5
    btnSelected.layer.borderColor = UIColor.lightGray.cgColor
    btnSelectSubCar.backgroundColor = .clear
    btnSelectSubCar.layer.cornerRadius = 5
    btnSelectSubCar.layer.borderWidth = 0.5
    btnSelectSubCar.layer.borderColor = UIColor.lightGray.cgColor
    btnSelectRegion.backgroundColor = .clear
    btnSelectRegion.layer.cornerRadius = 5
    btnSelectRegion.layer.borderWidth = 0.5
    btnSelectRegion.layer.borderColor = UIColor.lightGray.cgColor
    btnSelectCity.backgroundColor = .clear
    btnSelectCity.layer.cornerRadius = 5
    btnSelectCity.layer.borderWidth = 0.5
    btnSelectCity.layer.borderColor = UIColor.lightGray.cgColor
    let addresse : String = Share.sharedName.nameAdresse ?? "name of adreesee"
    btnSelectAdresse.setTitle(addresse,for: .normal)
    let cn : String = Share.sharedName.categorieName ?? "Select Categorie"
    let id : Int = Share.sharedName.categorieId ?? 1
    print(id)
    btnSelected.setTitle(cn,for: .normal)
    let cnsub : String = Share.sharedName.subcategorieName ?? "Select sub Categorie"
    btnSelectSubCar.setTitle(cnsub,for: .normal)
    
    let region : String = Share.sharedName.RegionName ?? "Select region"
    let idregion : Int = Share.sharedName.RegionId ?? 1
    print(idregion)
    btnSelectRegion.setTitle(region,for: .normal)
    let city : String = Share.sharedName.subcategorieName ?? "Select city"
    btnSelectCity.setTitle(city,for: .normal)
    priceTextField.placeholder = updateAmount()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   

    }
private func initScrollView() {

            step1View.layer.isHidden = false
            step2View.layer.isHidden = true
            step3View.layer.isHidden = true
            step4View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
 doneLabel.layer.isHidden = true
    
        
    
    }

    func updateAmount() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let amoun = Double(amount/100) + Double(amount%100)/100
        return formatter.string(from: NSNumber(value: amoun))
    }
    
    @IBAction func stepperButton(_ sender: UIStepper) {
        nombreAlLabel.text = String(sender.value)
    }
    @IBAction func selectCateButton(_ sender: Any) {
        let modalViewController = PoPupCategorieViewController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
    
    }
    @IBAction func NexButton(_ sender: Any) {
        
        self.stepIndicatorView.currentStep += 1
       
    
        if(stepIndicatorView.currentStep == 1)
        {

            step1View.layer.isHidden = true
            step3View.layer.isHidden = true
            step2View.layer.isHidden = false
            doneLabel.layer.isHidden = true
                 step4View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true

        }
       else  if(stepIndicatorView.currentStep == 2)
        {
            step1View.layer.isHidden = true
            step2View.layer.isHidden = true
            step3View.layer.isHidden = false
            step4View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
            doneLabel.layer.isHidden = true
            
        }
            
       else  if(stepIndicatorView.currentStep == 3)
        {
            step1View.layer.isHidden = true
            step2View.layer.isHidden = true
            step3View.layer.isHidden = true
            step4View.layer.isHidden = false
            ajouterProduit.layer.isHidden = true
            doneLabel.layer.isHidden = true
        }
        else
        {
            doneLabel.layer.isHidden = false
            step1View.layer.isHidden = true
            step2View.layer.isHidden = true
            step3View.layer.isHidden = true
            step4View.layer.isHidden = true
            nextButton.layer.isHidden = true
            ajouterProduit.layer.isHidden = false
    
        }
      
    }
    

//
//    /************** Post ***************/
//    func postProduct() {
//        let urlString = "https://clocation.azurewebsites.net/api/Products"
//        print(" contaz.list[contaz.defaultSelectedIndex]] \( (comboxviewCat.list[comboxviewCat.defaultSelectedIndex] as AnyObject))")
//                AF.request(urlString, method: .post, parameters: ["name": nameTextField.text! , "description" : descriptionText.text! , "price" : priceTextField.text! , "address" : addressTextField.text! , "enumSubCategoryId" : sousCategoriList[comboxviewSubCat.defaultSelectedIndex].enumCategoryId],encoding: JSONEncoding.default, headers: nil).responseJSON {
//                    response in
//
//                    switch response.result {
//                    case .success:
//                        print(response)
//
//                        break
//                    case .failure(let error):
//
//                        print(error)
//                    }
//                }
//    }
    
    //
    @IBAction func addAction(_ sender: Any) {
       // postProduct()
      
    }
    
    @IBAction func imageButton(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            //check if  the camera existe in our uiimagepickercontroller or not
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController , animated: true , completion: nil)
                
            }else {
                print("camera not availble")
                let alertController = UIAlertController(title: "Error", message: "camera not availble", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController,animated: true, completion: nil)
            }
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController , animated: true , completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:  nil))
        self.present(actionSheet , animated: true , completion: nil)
    }
//    func setupCombox() {
//        etatCombox.dataSource = self
//        etatCombox.delegate = self
//        etatCombox.showMaxCount = 4
//        etatCombox.defaultSelectedIndex = 1 //start from 0
//        etatCombox.dataSource = self
//        etatCombox.delegate = self
//    }
}
extension AjouterProduitViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let digit = Int(string) {
            amount = amount * 10 + digit
            priceTextField.text = updateAmount()
        }
        if string == "" {
            amount = amount/10
            priceTextField.text = updateAmount()
        }
        return false
    }

}

//extension AjouterProduitViewController: SWComboxViewDataSourcce {
//    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
//     
//            return ["Nouveau", "D'occation- Comme Neuf", "Utilisé, Bon", "Utilisé, Acceptable", "Utilisé, Avoir des défauts", "Remis à neuf par le fabricant", "Remis à neuf"]
//       
//   
//    }
//    
//    func comboxSeletionView(combox: SWComboxView) -> SWComboxSelectionView {
//
//            return SWComboxTextSelection()
//  
//    }
//    
//    func configureComboxCell(combox: SWComboxView, cell: inout SWComboxSelectionCell) {
//        if combox == etatCombox {
//            cell.selectionStyle = .none
//            cell.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
//        }
//    }
//}
//
//extension AjouterProduitViewController : SWComboxViewDelegate {
//    //MARK: delegate
//    func comboxSelected(atIndex index:Int, object: Any, combox withCombox: SWComboxView) {
//        print("index - \(index) selected - \(object)")
//    }
//    
//    func comboxOpened(isOpen: Bool, combox: SWComboxView) {
//      
//    }
//}


extension AjouterProduitViewController : dataCollectionProtocol {
    func deleteData(indx: Int) {
        imgArr.remove(at : indx)
        collectionView.reloadData()
    }
}
extension AjouterProduitViewController : UICollectionViewDataSource , UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PictureCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PictureCollectionViewCell
        cell.imageProduit.image = imgArr[indexPath.row]
        cell.index = indexPath
        cell.delegate = self
        return cell
    }
    
}
extension AjouterProduitViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        return CGSize(width: bounds.width/2 - 10, height: 270)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
extension AjouterProduitViewController :  UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    //to get the real imaage that the user has to pick
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if  let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgArr.append(image)
            collectionView.reloadData()
        }
        
        //prendre image and put it in the delegete
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
