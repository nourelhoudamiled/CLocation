//
//  RegisterViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 04/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
class RegisterViewController: UIViewController  {

    @IBOutlet var siteLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var nameSocietLabel: UILabel!
    @IBOutlet var viewRegister: UIView!
    @IBOutlet var signIn: UIButton!
    @IBOutlet var descriptionTextfield: UITextField!
    @IBOutlet var sitesocieteTextfield: UITextField!
    @IBOutlet var nomsocieteTextField: UITextField!
    @IBOutlet var numtelTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var PassTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var tuesTextfield: UITextField!
      var list = ["Societe" , "Particulier"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signIn.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        signIn.layer.cornerRadius = 0.5 * signIn.bounds.size.width
 self.pickerView.isHidden = true
    }
    override func viewDidLayoutSubviews() {
        viewRegister.roundCorners(corners: [.bottomLeft], radius: 40.0)
        
        
    }
    @IBAction func registerButton(_ sender: Any) {
        let value = numtelTextField.text!
        let rewardInt = Int(value)
        
        var params :[String: AnyObject]?
        if (self.tuesTextfield.text == "Particulier" ) {
       
            params = (["firstName": "string", "lastName": "string","aboutMe": "string" ,  "skype": "string","facebookUrl": "string","twitterUrl": "string","linkedinUrl": "string", "pinterestUrl": "string", "imageUri": "string", "isAdmin": false, "email" : emailTextField.text!, "password" : PassTextField.text! , "phoneNumber" : rewardInt! , "isPartner" : false , "partnerAddress" :addressTextField.text!, "partnerCity" : cityTextField.text! ,  "partnerDescription": "string",
            "partnerName": "string", "partnerWebSite": "string" ] as [String : AnyObject])
            
            var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/users")!)
            urlRequest.setValue("application/json",
                                forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json",
                                forHTTPHeaderField: "Accept")
            
            let urlString = urlRequest.url?.absoluteString
            
            AF.request(urlString!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                do {
                guard let data = response.data else {return}

                 let userListJson = try JSONDecoder().decode(User.self, from: data)
                    Share.sharedName.idUser = userListJson.id

                print(response.value as Any)
                }catch let err {
                    print(err)
                }
            }
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorielViewController") as! TutorielViewController
//            present(vc, animated: true, completion: nil)
        } else {
            params = ["email" : emailTextField.text!, "password" : PassTextField.text! , "phoneNumber" : rewardInt! , "isPartner" : true , "partnerAddress" :addressTextField.text!, "partnerCity" : cityTextField.text! , "partnerDescription" :descriptionTextfield.text!, "partnerName" : nomsocieteTextField.text! , "partnerWebSite" :sitesocieteTextfield.text! ] as [String : AnyObject]
            
            var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/users")!)
            urlRequest.setValue("application/json",
                                forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json",
                                forHTTPHeaderField: "Accept")
            
            let urlString = urlRequest.url?.absoluteString
            
            AF.request(urlString!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                
                print(response.value as Any)
            }
        }
    }
    
    @IBAction func gotoLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension RegisterViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return list.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.tuesTextfield.text = self.list[row]
        self.pickerView.isHidden = true
        if  (  self.tuesTextfield.text  == "Particulier") {
            self.pickerView.isHidden = true
            self.nomsocieteTextField.isHidden = true
            self.descriptionTextfield.isHidden = true
            self.sitesocieteTextfield.isHidden = true
            self.nameSocietLabel.isHidden = true
            self.descriptionLabel.isHidden = true
            self.siteLabel.isHidden = true
          
        }
        else if (self.tuesTextfield.text == "Societe" )  {
            self.pickerView.isHidden = true
            self.descriptionTextfield.isHidden = false
            self.nomsocieteTextField.isHidden = false
            self.sitesocieteTextfield.isHidden = false
            self.nameSocietLabel.isHidden = false
            self.descriptionLabel.isHidden = false
            self.siteLabel.isHidden = false
        
       
            
        }
        
    }
    
}
extension RegisterViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.tuesTextfield {
            self.pickerView.isHidden = false
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
    }

}
