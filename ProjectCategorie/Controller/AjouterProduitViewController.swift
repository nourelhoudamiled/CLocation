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
    @IBOutlet var step4View: UIView!
    @IBOutlet var btnSelectSubCar: UIButton!
    @IBOutlet var btnSelected: UIButton!
    @IBOutlet var stepIndicatorView: StepIndicatorView!
    @IBOutlet var step3View: UIView!
    @IBOutlet var step1View: UIView!
    
    @IBOutlet var step2View: UIView!
    
    @IBOutlet var minDuréLabel: UITextField!
    
    @IBOutlet var descriptionText: UITextField!
    
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var availbleSwith: UISwitch!
    let imagePickerController = UIImagePickerController()
    var imgArr: [URL]! = []
    @IBOutlet var priceTextField: UITextField!
    
    var amount : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        initScrollView()
        
        imagePickerController.delegate = self
        if revealViewController() != nil {
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            
            navigationItem.title = " Ajouter Produit "
            
            
        }
        
        let path = "/Users/macbook/Downloads/insights-for-instagram-master/README.md"
        
        do {
            // Get the contents
            let contents = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
            print(contents)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: (error)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        single()
        
    }
    @IBAction func adresseButton(_ sender: Any) {
        
        
    }
    func  single() {
        
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
            step3View.layer.isHidden = true
            step2View.layer.isHidden = false
            doneLabel.layer.isHidden = true
            step4View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
            nextButton.layer.isHidden = false
            
            
        }
        else  if(stepIndicatorView.currentStep == 2)
        { print("backstep3")
            step1View.layer.isHidden = true
            step2View.layer.isHidden = true
            step3View.layer.isHidden = false
            step4View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
            doneLabel.layer.isHidden = true
            nextButton.layer.isHidden = false
            
            
        }
            
        else  if(stepIndicatorView.currentStep == 3)
        {print("step4")
            step1View.layer.isHidden = true
            step2View.layer.isHidden = true
            step3View.layer.isHidden = true
            step4View.layer.isHidden = false
            ajouterProduit.layer.isHidden = true
            doneLabel.layer.isHidden = true
            nextButton.layer.isHidden = false
            
        }
        else
        {
            print("backstep1")
            step1View.layer.isHidden = false
            step2View.layer.isHidden = true
            step3View.layer.isHidden = true
            step4View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
            doneLabel.layer.isHidden = true
            nextButton.layer.isHidden = false
            backButton.layer.isHidden = true
            
            
        }
        
    }
    @IBAction func NexButton(_ sender: Any) {
        
        self.stepIndicatorView.currentStep += 1
        
        
        if(stepIndicatorView.currentStep == 1)
        {
            print("step2")
            let addresse : String = Share.sharedName.nameAdresse ?? "name of adresse"
            btnSelectAdresse.setTitle(addresse,for: .normal)
            btnSelectAdresse.backgroundColor = .clear
            btnSelectAdresse.layer.cornerRadius = 5
            btnSelectAdresse.layer.borderWidth = 0.5
            btnSelectAdresse.layer.borderColor = UIColor.lightGray.cgColor
            step1View.layer.isHidden = true
            step3View.layer.isHidden = true
            step2View.layer.isHidden = false
            doneLabel.layer.isHidden = true
            step4View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
            backButton.layer.isHidden = false
            
        }
        else  if(stepIndicatorView.currentStep == 2)
        {print("step3")
            step1View.layer.isHidden = true
            step2View.layer.isHidden = true
            step3View.layer.isHidden = false
            step4View.layer.isHidden = true
            ajouterProduit.layer.isHidden = true
            doneLabel.layer.isHidden = true
            backButton.layer.isHidden = false
            
        }
            
        else  if(stepIndicatorView.currentStep == 3)
        {
            print("step4")
            step1View.layer.isHidden = true
            step2View.layer.isHidden = true
            step3View.layer.isHidden = true
            step4View.layer.isHidden = false
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
            nextButton.layer.isHidden = true
            ajouterProduit.layer.isHidden = false
            backButton.layer.isHidden = false
            
            
        }
        
    }
    
    
    //
    func postAttachement() {
        let urlStringAttachments = "https://clocation.azurewebsites.net/api/Attachments"
        // Set the file path
        
        //        let profileImageUrl = "\(Share.sharedName.imgArr!)"
        
        
        //        let path: String = Share.sharedName.imgArr!
        //   imageData = UIImagePNGRepresentation(image)
        //        let url = NSURL(string: Share.sharedName.imgArr!)
        
        AF.request(urlStringAttachments, method: .post, parameters: ["productId" : 92 , "files" : [] ],encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            do {
                guard let data = response.data else {return}
                print(response.value)
                print(response.result)
                
                
            }catch let error {
                print(error)
            }
            
        }
        
    }
    //    /************** Post ***************/
    func postProduct() {
        
        let urlString = "https://clocation.azurewebsites.net/api/Products"
        
        let idsub : Int = Share.sharedName.SubcategorieId ?? 2
        AF.request(urlString, method: .post, parameters: ["name": nameTextField.text! , "description" : descriptionText.text! , "price" : "\(priceTextField.text!)" , "userGuide" : "ddd" ,  "address" : Share.sharedName.nameAdresse  , "enumSubCategoryId" : idsub , "delegation" : "delegation" , "positionLatitude" : 11 ,"positionLongitude" : 12 , "userId" : "1b7e52ac-77ca-4612-8a87-aafab5feee65", "enumCityId" : 4, "enumUniteId" : 3 ,  "files" : "28_37e05407-41b6-499a-9f06-06330dc87458.PNG"], headers: nil).responseJSON {
            response in
            
            print(response.value ?? "zz")
            print(response.result)
            
            
            
        }
    }
    
    
    @IBAction func addAction(_ sender: Any) {
        // postProduct()
        postAttachement()
        
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
        
        let profileImageUrl = imgArr[indexPath.row]
        
        cell.imageProduit.loadImageUsingCacheWithUrlString(profileImageUrl.absoluteString)
        print(profileImageUrl.absoluteString)
        //            cell.imageProduit.image = imgArr[indexPath.row]
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
    //to get the real imaage that the user has to pick
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        let asset = info[UIImagePickerController.InfoKey.phAsset]
        //        let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        //        var im = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        //        if let ed = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
        //            im = ed
        //        }
        if  let image = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            imgArr.append(image)
            
            collectionView.reloadData()
        }
        print("image \(imgArr!)")
        Share.sharedName.imgArr = imgArr
        
        print("image share \(Share.sharedName.imgArr!)")
        
        
        
        
        //prendre image and put it in the delegete
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
