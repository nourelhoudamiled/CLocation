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

    @IBOutlet var viewLogin: UIView!
    @IBOutlet var PassTextField: SkyFloatingLabelTextField!
    @IBOutlet var nameLabel: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        loginButton.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        loginButton.layer.cornerRadius = 0.5 * loginButton.bounds.size.width
//        loginButton.layer.cornerRadius = 50.0
      
        signInWithFb.layer.cornerRadius = 10.0
        
    }
    override func viewDidLayoutSubviews() {
        viewLogin.roundCorners(corners: [.bottomLeft], radius: 80.0)
     
        
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        let userLoggedIn = UserDefaults.standard.bool(forKey: "LOGGED_IN")
        
        let token = loginService?.oauth2.accessToken
        
        if (!userLoggedIn || (userLoggedIn && token == nil))  {
            if nameLabel.text!.isEmpty {
                let userMessage : String = "Please type in your email addresse"
                displayMessage(userMessage: userMessage)
                return
            }
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
    func displayMessage(userMessage : String)
    {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default ) {
            action in
            self.dismiss(animated: true, completion: nil)
        }
        myAlert.addAction(okAction)
        self.present(myAlert , animated : true , completion : nil)
        
    }
    
}

