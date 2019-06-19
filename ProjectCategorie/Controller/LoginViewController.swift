//
//  LoginViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 04/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
class LoginViewController: UIViewController {
       var loginService: BaseService?
    @IBOutlet var signInWithFb: UIButton!
    @IBOutlet var loginButton: UIButton!
    var user : User?

    @IBOutlet var viewLogin: UIView!
    @IBOutlet var PassTextField: SkyFloatingLabelTextField!
    @IBOutlet var nameLabel: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        loginButton.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
       // loginButton.layer.cornerRadius = 0.5 * loginButton.bounds.size.width
//        loginButton.layer.cornerRadius = 50.0
              
    }
    override func viewDidLayoutSubviews() {
        viewLogin.roundCorners(corners: [.bottomLeft], radius: 80.0)
     
        
    }
  
    
    @IBAction func LoginButton(_ sender: Any) {
        
        if self.nameLabel.text == "" || self.PassTextField.text == "" {
            displayMessage(userMessage: "Entrez un e-mail et mot de passe valides")
            
        }
        else {
            loginService = BaseService(clientID: "postman-api", clientSecret: "secret", username: nameLabel.text!, password: PassTextField.text!)
            loginService?.authorize(presenting: self, completion: {
                
                let userStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = userStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController")
                            // present(vc, animated: true, completion: nil)
                            self.navigationController?.pushViewController(vc, animated: true)
            })
//
     

            
        }
        
        
//        let userLoggedIn = UserDefaults.standard.bool(forKey: "LOGGED_IN")
        
        
//        if (!userLoggedIn || (userLoggedIn ))  {
//            if nameLabel.text!.isEmpty {
//                let userMessage : String = "Please type in your email addresse"
//                displayMessage(userMessage: userMessage)
//                return
//            }
//            loginService = BaseService(clientID: "postman-api", clientSecret: "secret", username: nameLabel.text!, password: PassTextField.text!)
//
//            loginService?.authorize(presenting: self)
////            print( " users ids 2 : \(AppManager.shared.iduser)")
//
//
//            UserDefaults.standard.setIsLoggedIn(value: true)
//            let prefs:UserDefaults = UserDefaults.standard
//
//            prefs.set(1, forKey: "IsLoggedIn")
//            prefs.synchronize()
//
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorielViewController") as! TutorielViewController
//            present(vc, animated: true, completion: nil)
//    }
    }
    
    
}

