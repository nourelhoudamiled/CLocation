//
//  RegisterViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 04/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
import SkyFloatingLabelTextField
class RegisterViewController: UIViewController  , UITextFieldDelegate {

    @IBOutlet var firstNameLabel: SkyFloatingLabelTextField!
    @IBOutlet var lastNameLabel: SkyFloatingLabelTextField!
    @IBOutlet var siteLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var nameSocietLabel: UILabel!
    @IBOutlet var viewRegister: UIView!
    @IBOutlet var signIn: UIButton!
    @IBOutlet var descriptionTextfield: UITextField!
    @IBOutlet var sitesocieteTextfield: UITextField!
    @IBOutlet var nomsocieteTextField: UITextField!
    @IBOutlet var numtelTextField: SkyFloatingLabelTextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var PassTextField: SkyFloatingLabelTextField!
    @IBOutlet var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var tuesTextfield: UITextField!
      var list = ["Societe" , "Particulier"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numtelTextField.delegate = self                  //set delegate

        signIn.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
       
 self.pickerView.isHidden = true
    }

    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    @IBAction func registerButton(_ sender: Any) {
      
        let favorite : String = "do you confirme your registration ?"
        let alert = UIAlertController(title: "Alert", message: favorite, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "no", style: .default, handler:nil))
        
        self.present(alert, animated: true)
        
    
//        let value = numtelTextField.text!
//        let rewardInt = Int(value)
//
////        if (self.tuesTextfield.text == "Particulier" ) {
//        if self.emailTextField.text == "" || self.PassTextField.text == "" ||  self.numtelTextField.text == "" || self.firstNameLabel.text == "" ||  self.lastNameLabel.text == "" {
//            displayMessage(userMessage: "Fill your field")
//
//        }
//        if !isValidEmail(testStr: emailTextField.text!) {
//             displayMessage(userMessage: "Fill in your email in this form email name@example.com")
//        }
//        if numtelTextField.text?.count != 8 {
//            displayMessage(userMessage: "The phone number should be equal to eight")
//        }
////
//
//
//        let params = ["firstName": firstNameLabel.text!, "lastName": lastNameLabel.text!,"aboutMe": "", "email" : emailTextField.text!, "password" : PassTextField.text! , "phoneNumber" : numtelTextField.text! , "isPartner" : false , "skype": "","facebookUrl": "","twitterUrl": "",
//            "linkedinUrl": "", "pinterestUrl": "", "imageUri": "", "isAdmin": false,"partnerAddress" :"", "partnerCity" : "" , "partnerDescription" : "", "partnerName" : "" , "partnerWebSite" : "" ] as! [String : Any]
//        print(params)
//
//        var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/users")!)
//        urlRequest.setValue("application/json",
//                            forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue("application/json",
//                            forHTTPHeaderField: "Accept")
//
//        let urlString = urlRequest.url?.absoluteString
//
//        AF.request(urlString!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
//            do {
//                print("response.value\(response)")
//                print("response.value\(response.value)")
//
//                guard let data = response.data else {return}
//
//                let userListJson = try JSONDecoder().decode(User.self, from: data)
//                print("response.value\(userListJson)")
//
//                let userStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = userStoryboard.instantiateViewController(withIdentifier: "TutorielViewController")
//
//                self.navigationController?.pushViewController(vc, animated: true)
//
//            }
//            catch let err {
//                print(err)
//            }
//        }
        
      //}
//        else {
//            let params = ["email" : emailTextField.text!, "password" : PassTextField.text! , "phoneNumber" : rewardInt! , "isPartner" : true , "partnerAddress" :addressTextField.text!, "partnerCity" : cityTextField.text! , "partnerDescription" :descriptionTextfield.text!, "partnerName" : nomsocieteTextField.text! , "partnerWebSite" :sitesocieteTextfield.text! ] as [String : Any]
//
//            var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/users")!)
//            urlRequest.setValue("application/json",
//                                forHTTPHeaderField: "Content-Type")
//            urlRequest.setValue("application/json",
//                                forHTTPHeaderField: "Accept")
//
//            let urlString = urlRequest.url?.absoluteString
//
//            AF.request(urlString!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
//
//                print(response.value as Any)
//            }
//        }
    }
    
    @IBAction func gotoLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension RegisterViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterCell", for: indexPath) as! RegisterCell
        cell.labelName.text = "jkhkjhkhj"
        
return cell
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        var count = textField.text?.count
//        if count! < 8 && count! > 2 {
//            print("ok")
//            return false
//        }
//        else {
//            displayMessage(userMessage: "llkkkkkk")
//            print("ko")
//            return true
//        }
        return true
        
    }
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        <#code#>
//    }
    
}
//extension RegisterViewController : UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        if textField == self.tuesTextfield {
//            self.pickerView.isHidden = false
//            //if you dont want the users to se the keyboard type:
//
//            textField.endEditing(true)
//        }
//    }
//
//}
