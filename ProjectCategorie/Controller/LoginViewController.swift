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
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var viewLogin: UIView!
    @IBOutlet var PassTextField: SkyFloatingLabelTextField!
    @IBOutlet var nameLabel: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLogin.layer.cornerRadius = 0.2 * viewLogin.bounds.size.width
        viewLogin.clipsToBounds = true
//        loginButton.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
//        loginButton.layer.cornerRadius = 0.5 * loginButton.bounds.size.width
//        loginButton.clipsToBounds = true
        
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        let userLoggedIn = UserDefaults.standard.bool(forKey: "LOGGED_IN")
        
        let token = loginService?.oauth2.accessToken
        
        if (!userLoggedIn || (userLoggedIn && token == nil))  {
            
            loginService = BaseService(clientID: "postman-api", clientSecret: "secret", username: nameLabel.text!, password: PassTextField.text!)
            
            loginService?.authorize(presenting: self, texttoken: "")
            UserDefaults.standard.setIsLoggedIn(value: true)
            let prefs:UserDefaults = UserDefaults.standard
            
            prefs.set(1, forKey: "IsLoggedIn")
            prefs.synchronize()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            present(vc, animated: true, completion: nil)
    }
    }
    
    
    
}

