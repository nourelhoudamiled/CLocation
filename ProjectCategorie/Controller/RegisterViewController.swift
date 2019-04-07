//
//  RegisterViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 04/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
class RegisterViewController: UIViewController {

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
 self.pickerView.isHidden = true
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let value = numtelTextField.text!
        let rewardInt = Int(value)
        
        var params :[String: AnyObject]?
        if (self.tuesTextfield.text == "Particulier" ) {
            params = (["email" : emailTextField.text!, "password" : PassTextField.text! , "phoneNumber" : rewardInt! , "isPartner" : false , "partnerAddress" :addressTextField.text!, "partnerCity" : cityTextField.text! ] as [String : AnyObject])
            
            var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/users")!)
            urlRequest.setValue("application/json",
                                forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json",
                                forHTTPHeaderField: "Accept")
            
            let urlString = urlRequest.url?.absoluteString
            
            AF.request(urlString!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                
                print(response.value as Any)
            }
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
        if  (  self.tuesTextfield.text  == "Particulier"  && self.list[row] == "Particulier" ) {
            self.pickerView.isHidden = true
            self.nomsocieteTextField.isHidden = true
            self.descriptionTextfield.isHidden = true
            self.sitesocieteTextfield.isHidden = true
          
        }
        else if (self.tuesTextfield.text == "Societe" && self.list[row] == "Societe"  )  {
            self.pickerView.isHidden = true
            self.descriptionTextfield.isHidden = false
            self.nomsocieteTextField.isHidden = false
            self.sitesocieteTextfield.isHidden = false
        
       
            
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
