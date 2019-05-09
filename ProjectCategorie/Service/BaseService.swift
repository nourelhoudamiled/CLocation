//
//  BaseService.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 04/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import Alamofire
import p2_OAuth2
import JWTDecode
final class BaseService: OAuth2PasswordGrantDelegate
    
{
    // var manager: Manager?
    
    
    var userList = [String]()
    
    var text:String = ""
    public var oauth2: OAuth2PasswordGrant
    var userid : String?
    
    
    init(clientID: String, clientSecret: String, username: String, password: String ) {
        oauth2 = OAuth2PasswordGrant(settings: [
            "client_id": clientID,
            "client_secret": clientSecret,
            "authorize_uri": "",
            "token_uri": "https://clocation-idserver.azurewebsites.net/connect/token",
            "grant_type": "password",
            "scope": "openid api1 email profile",
            "keychain": false,
            "verbose": true
            ] as OAuth2JSON)
        
        
        
        oauth2.username = username
        oauth2.password = password
        oauth2.delegate = self
    }
    func displayMessage(userMessage : String)
    {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let vc = self.oauth2.authConfig.authorizeContext as? UIViewController
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default ) {
            action in
            vc!.dismiss(animated: true, completion: nil)
        }
        myAlert.addAction(okAction)
        vc!.present(myAlert , animated : true , completion : nil)
        
    }
    
    
    public func authorize(presenting view: UIViewController) {
        // oauth2.authConfig.authorizeContext = view
        oauth2.logger = OAuth2DebugLogger(.trace)
        var token = ""
        // oauth2.verbose = true
        // as far as I know now, the following if-request is not necessary
        // because "authorizeEmbedded" is checking it already
        if oauth2.isAuthorizing {
            oauth2.abortAuthorization()
            print("ee")
            
            return
        }
        
        if let view = view as? OAuth2PasswordGrantDelegate {
            oauth2.delegate = view
        }
        
        oauth2.authorizeEmbedded(from: view) { (authParams, error) in
            if let au = authParams {
                //                print("oauth2.authParameters\(self.oauth2.authParameters)")
                //                print("oauth2.idtoken\(self.oauth2.idToken)")
                //                print("oauth2.loger\(self.oauth2.logger)")
                
                let token : AnyObject = au["access_token"] as AnyObject
                do {
                    
                    let jwt = try decode(jwt: token as! String)
                    
                    print("sub the id of user \(jwt.subject)")
                    print("jwt \(jwt)")
               
                    AppManager.shared.token = token as? String
                    AppManager.shared.iduser = jwt.subject

                    UserDefaults.standard.set(token, forKey: "Token")
                    guard let beare = au["token_type"] as! String? else { return}
                    print("The value of token is \(beare+(token as! String))")
                    let headers : HTTPHeaders = [
                        "Authorization": "\(beare) \(token) "]
                    print("e")
                    print(headers)
                var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Users/\(jwt.subject!)")!)
                    let urlString = urlRequest.url?.absoluteString
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        AF.request(urlString!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                            guard let data = response.data else {return}
                            do {
                                 let user = try JSONDecoder().decode(User.self, from: data)
                                AppManager.shared.user = user
                                print(user.id)
                                print(response.request as Any)  // original URL request
                                print(response.response as Any) // URL response
                                
                                
                            }catch let err {
                                print(err)
                            }
                        }
                        
                        
                    }
                
            } catch {
                print("Failed to decode JWT: \(error)")
            }
            }
                else {
                    UserDefaults.standard.setIsLoggedIn(value: false)
                    print("Authorization was canceled or went wrong: \(String(describing: error?.description))")
                }
            }
      
        
        
    }
    
    
    public func loginController(oauth2: OAuth2PasswordGrant) -> AnyObject {
        if let vc = oauth2.authConfig.authorizeContext as? UIViewController {
            vc.present(LoginViewController(), animated: true)
        }
        return LoginViewController()
    }
    
    
}
