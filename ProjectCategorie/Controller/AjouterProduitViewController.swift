//
//  AjouterProduitViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 29/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

import Alamofire
import ALCameraViewController
import SWCombox
import StepIndicator
import Photos

class AjouterProduitViewController: UIViewController {
    @IBOutlet var columnTableView: UITableView!
//
    @IBOutlet var btnSelectUnite: UIButton!
    @IBOutlet var btnSelectEtat: UIButton!
    @IBOutlet var switchDisponible: UISwitch!
    @IBOutlet var delegationTextField: UITextField!
    @IBOutlet var userguideTextField: UITextField!
    @IBOutlet var step3View: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var doneLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nombreAlLabel: UILabel!
    @IBOutlet var btnSelectAdresse: UIButton!
    // make sure you apply the correct encapsulation principles in your classes
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var btnSelectCity: UIButton!
    
    @IBOutlet var ajouterProduit: UIButton!
    @IBOutlet var btnSelectRegion: UIButton!
    @IBOutlet var step5View: UIView!
    @IBOutlet var btnSelectSubCar: UIButton!
    @IBOutlet var btnSelected: UIButton!
    @IBOutlet var stepIndicatorView: StepIndicatorView!
    @IBOutlet var step4View: UIView!
    @IBOutlet var step1View: UIView!

    @IBOutlet var step2View: UIView!
    
    
    @IBOutlet var hiddenText: UITextField!
    @IBOutlet var descriptionText: UITextField!
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/SubCategory/Column/")!)
       var urlRequestAtt = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments")!)
    var columnList = [Column]()

    @IBOutlet var nameTextField: UITextField!
//    @IBOutlet var availbleSwith: UISwitch!
    var imgArr: [UIImage]! = []
    @IBOutlet var priceTextField: UITextField!
    
    var amount : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
//        UPLOD()
        hiddenText.isHidden = true

        if revealViewController() != nil {
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            
            navigationItem.title = " Ajouter Produit "
            
            
        }
        columnTableView.rowHeight = UITableView.automaticDimension
        columnTableView.estimatedRowHeight = 100
        print("Token ViewCont ViewDidAppear = \(UserDefaults.standard.string(forKey: "Token"))")

          initScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cn : String = Share.sharedName.categorieName ?? "Select Categorie"
        let id : Int = Share.sharedName.categorieId ?? 1
        print(id)
        btnSelected.setTitle(cn,for: .normal)
        let cnsub : String = Share.sharedName.subcategorieName ?? "Select sub Categorie"
        
        btnSelectSubCar.setTitle(cnsub,for: .normal)
     single()

        
        
        
    }
    @IBAction func adresseButton(_ sender: Any) {
        
        
    }
    func  single() {
      
        btnSelected.backgroundColor = .clear
        btnSelected.layer.cornerRadius = 5
        btnSelected.layer.borderWidth = 0.5
        btnSelected.layer.borderColor = UIColor.lightGray.cgColor
        btnSelectUnite.backgroundColor = .clear
        btnSelectUnite.layer.cornerRadius = 5
        btnSelectUnite.layer.borderWidth = 0.5
        btnSelectUnite.layer.borderColor = UIColor.lightGray.cgColor
        btnSelectEtat.backgroundColor = .clear
        btnSelectEtat.layer.cornerRadius = 5
        btnSelectEtat.layer.borderWidth = 0.5
        btnSelectEtat.layer.borderColor = UIColor.lightGray.cgColor
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
        let addresse : String = Share.sharedName.nameAdresse ?? "name of adresse"
        btnSelectAdresse.setTitle(addresse,for: .normal)
        let region : String = Share.sharedName.RegionName ?? "Select region"
        let idregion : Int = Share.sharedName.RegionId ?? 1
        print(idregion)
        btnSelectRegion.setTitle(region,for: .normal)
        let unite : String = Share.sharedName.uniteName ?? "Select unite"
        let idunite : Int = Share.sharedName.uniteId ?? 1
        print(idunite)
        btnSelectUnite.setTitle(unite,for: .normal)
        let etat : String = Share.sharedName.etatName ?? "Select etat"
        let idetat : Int = Share.sharedName.etatId ?? 1
        print(idetat)
        btnSelectEtat.setTitle(etat,for: .normal)
        let city : String = Share.sharedName.CityName ?? "Select city"
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
        step5View.layer.isHidden = true
        ajouterProduit.layer.isHidden = true
        doneLabel.layer.isHidden = true
        backButton.layer.isHidden = true
        
        
        
        
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
    @IBAction func BackButton(_ sender: Any) {
        self.stepIndicatorView.currentStep -= 1
        if(stepIndicatorView.currentStep == 1)
        {
            print("backstep2")
            step1View.layer.isHidden = true
            step4View.layer.isHidden = true
            step2View.layer.isHidden = false
            step3View.layer.isHidden = true
            doneLabel.layer.isHidden = true
            step5View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
            nextButton.layer.isHidden = false
            
            
        }
        else  if(stepIndicatorView.currentStep == 2)
        { print("backstep3")
            step1View.layer.isHidden = true
            step2View.layer.isHidden = true
            step3View.layer.isHidden = false
            step4View.layer.isHidden = true
            step5View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
            doneLabel.layer.isHidden = true
            nextButton.layer.isHidden = false
            
            
        }
            
        else  if(stepIndicatorView.currentStep == 3)
        {print("step4")
            step1View.layer.isHidden = true
            step2View.layer.isHidden = true
            step4View.layer.isHidden = false
            step3View.layer.isHidden = true
            step5View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
            doneLabel.layer.isHidden = true
            nextButton.layer.isHidden = false
            
        }
        else  if(stepIndicatorView.currentStep == 4)
        {print("step5")
            step1View.layer.isHidden = true
            step2View.layer.isHidden = true
            step4View.layer.isHidden = true
            step3View.layer.isHidden = true
            step5View.layer.isHidden = false
            ajouterProduit.layer.isHidden = true
            doneLabel.layer.isHidden = true
            nextButton.layer.isHidden = false
            
        }
        else
        {
            print("backstep1")
            step1View.layer.isHidden = false
            step2View.layer.isHidden = true
            step4View.layer.isHidden = true
             step3View.layer.isHidden = true
            step5View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
            doneLabel.layer.isHidden = true
            nextButton.layer.isHidden = false
            backButton.layer.isHidden = true
            
            
        }
        
    }
    @IBAction func uploadBtton(_ sender: Any) {
//        myImageUploadRequest ()
//        imgArr.append(self.imageView.image!)
    }
    @IBAction func NexButton(_ sender: Any) {
        self.stepIndicatorView.currentStep += 1
        
        
        if(stepIndicatorView.currentStep == 1)
        {
            print("step2")
            
            btnSelectAdresse.backgroundColor = .clear
            btnSelectAdresse.layer.cornerRadius = 5
            btnSelectAdresse.layer.borderWidth = 0.5
            btnSelectAdresse.layer.borderColor = UIColor.lightGray.cgColor
            step1View.layer.isHidden = true
            step4View.layer.isHidden = true
            step3View.layer.isHidden = true
            step2View.layer.isHidden = false
            doneLabel.layer.isHidden = true
            step5View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
            backButton.layer.isHidden = false
            
        }
        else  if(stepIndicatorView.currentStep == 2)
        {print("step3")
            step1View.layer.isHidden = true
            step2View.layer.isHidden = true
            step4View.layer.isHidden = true
            step3View.layer.isHidden = false
            step5View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
            doneLabel.layer.isHidden = true
            backButton.layer.isHidden = false
            getColumnFields()

        }
            
        else  if(stepIndicatorView.currentStep == 3)
        {
            print("step4")
            step1View.layer.isHidden = true
            step2View.layer.isHidden = true
            step4View.layer.isHidden = false
            step5View.layer.isHidden = true
            step3View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
            doneLabel.layer.isHidden = true
            backButton.layer.isHidden = false
            
        }
        else  if(stepIndicatorView.currentStep == 4)
        {
            print("step5")
            step1View.layer.isHidden = true
            step2View.layer.isHidden = true
            step4View.layer.isHidden = true
            step5View.layer.isHidden = false
            step3View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
            doneLabel.layer.isHidden = true
            backButton.layer.isHidden = false
            
        }
        else
        { print("done")
            doneLabel.layer.isHidden = false
            step1View.layer.isHidden = true
            step2View.layer.isHidden = true
            step3View.layer.isHidden = true
            step4View.layer.isHidden = true
            step5View.layer.isHidden = true
            nextButton.layer.isHidden = true
            ajouterProduit.layer.isHidden = false
            backButton.layer.isHidden = false
            
            
        }
        
    }
    
 
   
    
  



     func createPhoto(photo: [UIImage]) {
        let urlString = "https://clocation.azurewebsites.net/api/Products"
        
        let idsub  = "\(Share.sharedName.SubcategorieId ?? 2)"
        let idunite  = "\(Share.sharedName.uniteId ?? 2)"
        let idetat  = "\(Share.sharedName.etatId ?? 1)"
         let longitude  = "\(Share.sharedName.longitude ?? 2)"
         let latitude  = "\(Share.sharedName.latitude ?? 2)"
         let idcity  = "\(Share.sharedName.CityId ?? 2)"
//        let userId  = Share.sharedName.idUser
        let userId = "5db395d9-3b02-4c27-bb19-0f4c6ce8b851"
        let nameAdd  = Share.sharedName.nameAdresse ?? ""
        let prix = "\(priceTextField.text!)"
        AF.upload(multipartFormData: { (form: MultipartFormData) in
            for pictures in photo {
            if let data = pictures.jpegData(compressionQuality: 0.75) {
                form.append(data, withName: "files",fileName: "file.jpg", mimeType: "image/jpg")
                }
                    form.append(self.nameTextField.text!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"name")
                if self.switchDisponible.isOn == true   {
                    self.hiddenText.text = "true"
                    form.append(self.hiddenText.text!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"IsAvailable")
                }
                else {
                    self.hiddenText.text = "false"
                    form.append(self.hiddenText.text!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"IsAvailable")
                }
                
    
   form.append(idetat.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"ProductStatusId")
                 form.append(self.descriptionText.text!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"description")
                 form.append(prix.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"price")
                 form.append(nameAdd.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"address")
                form.append(idsub.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"enumSubCategoryId")
                form.append(userId.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"userId")
                form.append(idcity.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"enumCityId")
                form.append(self.userguideTextField.text!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"userGuide")
                  form.append(self.delegationTextField.text!.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"delegation")
                  form.append(idunite.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"enumUniteId")
                form.append(latitude.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"positionLatitude")
                form.append(longitude.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"positionLongitude")
                
                
               
            }

        }, usingThreshold: MultipartFormData.encodingMemoryThreshold, to: urlString, method: .post).responseJSON { (response)in
                print(response)

            }
    }

    
    
    
    func getColumnFields () {
        
        let urlString = urlRequest.url?.absoluteString
        let id : Int = Share.sharedName.SubcategorieId ?? 2
        columnList.removeAll()
        let subCategorieURL = urlString! + "\(id)"
        AF.request(subCategorieURL , method : .get ).responseJSON {
            response in
            do {
                guard let data = response.data else {return}

                let columnJson = try JSONDecoder().decode([Column].self, from: data)
                for column in columnJson {
                    self.columnList.append(column)
                }
            
                print(response )
                DispatchQueue.main.async {
                    self.columnTableView.reloadData()
                }
        }
        catch let error {
            print(error)
        }
        
        
    }
    
}
  
    func UPLOD()
    {
        //Parameter HERE
        let parameters = [
            "ProductId": "39",
           
        ]
        //Header HERE
       
        
        let image = UIImage.init(named: "AnneHathaway")
        let imgData = image?.jpegData(compressionQuality: 0.7)!
        
        AF.upload(multipartFormData: { multipartFormData in
            //Parameter for Upload files
            multipartFormData.append(imgData!, withName: "files",fileName: "AnneHathaway.png" , mimeType: "image/png")
            
            for (key, value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, usingThreshold:UInt64.init(),
           to: "http://clocation.azurewebsites.net/api/Attachments", //URL Here
            method: .post).responseJSON { response in
                        print("the resopnse code is : \(response.response?.statusCode)")
                        print("the response is : \(response)")
                    }
        
    }

    @IBAction func resetButton(_ sender: Any) {
        descriptionText.text = ""
        priceTextField.text = ""
        nameTextField.text = ""
        
        
        
    }
    


@IBAction func addAction(_ sender: Any) {
    print("imgggggARRAYCOUNT = \(imgArr.count)")
    // postProduct()
//    postAttachement()
   createPhoto(photo: imgArr)

    
}

@IBAction func imageButton(_ sender: Any) {
    
//
//
//    let myPickerController = UIImagePickerController()
//    myPickerController.delegate = self
//    myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
//
//    self.present(myPickerController, animated: true, completion: nil)
        let imagePickerController = UIImagePickerController()

 imagePickerController.delegate = self

    let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)

    actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
        //check if  the camera existe in our uiimagepickercontroller or not

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            self.present(imagePickerController , animated: true , completion: nil)

        }else {
            print("camera not availble")
            let alertController = UIAlertController(title: "Error", message: "camera not availble", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController,animated: true, completion: nil)
        }


    }))

    actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in

        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController , animated: true , completion: nil)
    }))
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:  nil))
    self.present(actionSheet , animated: true , completion: nil)
}

}
extension AjouterProduitViewController : UITextFieldDelegate {
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        if let digit = Int(string) {
    //            amount = amount * 10 + digit
    //            priceTextField.text = updateAmount()
    //        }
    //        if string == "" {
    //            amount = amount/10
    //            priceTextField.text = updateAmount()
    //        }
    //        return false
    //    }
    
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
        
        //        let profileImageUrl = imgArr[indexPath.row]
        //
        //        cell.imageProduit.loadImageUsingCacheWithUrlString(profileImageUrl.absoluteString)
        //        print(profileImageUrl.absoluteString)
                  cell.imageProduit.image = imgArr[indexPath.row]
        print(imgArr)
        cell.index = indexPath
        cell.delegate = self
        
        
        
        return cell
    }
    
}
extension AjouterProduitViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right:5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        return CGSize(width: bounds.width/2 - 10, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
extension AjouterProduitViewController :  UIImagePickerControllerDelegate , UINavigationControllerDelegate {
   // to get the real imaage that the user has to pick
  

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 
            print("number of images  =\(imgArr.count + 1) ")

            //prendre image and put it in the delegete
            picker.dismiss(animated: true) {
                if self.imgArr.count > 2 {
                    let myAlert = UIAlertController(title: "Alert", message: "Nombre dépassé", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default ) {
                        action in

                        self.dismiss(animated: true, completion: nil)
                    }
                    myAlert.addAction(okAction)
                    self.present(myAlert , animated : true , completion : nil)

                }else
                {
                    if  let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                        //                    let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                        //                    let asset = result.firstObject
                        //                    print(asset?.value(forKey: "filename"))
                        self.imgArr.append(image)
//                        self.createPhoto(photo: image)
                        self.collectionView.reloadData()
                    }
                    print("image :\(self.imgArr)")
                }
            }
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true, completion: nil)
            }
    
    
      //  }
    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//
//                if  let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
//
//             self.imageView.image = image
//
//
//                }
//                  picker.dismiss(animated: true)
//        }
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            picker.dismiss(animated: true, completion: nil)
//        }
//
//
//
}
extension AjouterProduitViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return columnList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = columnTableView.dequeueReusableCell(withIdentifier: "ColumnTableViewCell") as! ColumnTableViewCell
        cell.columnLabel.text = columnList[indexPath.row].name
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor.red
        }else {
            
          cell.backgroundColor = UIColor.yellow
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
