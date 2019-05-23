//
//  BarMenuViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 04/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class BarMenuViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
     var loginServices: BaseService?
    @IBOutlet var nameProfile: UILabel!
    @IBOutlet var imageProfile: UIImageView!
    var menuNameArray:Array = [String]()
        var iconeImage:Array = [UIImage]()
    @IBOutlet var tableViews: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                menuNameArray = ["Profile" , "Discovery" ,  "Add Produit" ,"Booking"  , "Messages" , "Favorites",  "Sign Out"]
                iconeImage = [UIImage(named: "user-check-2") , UIImage(named: "search") ,UIImage(named: "edit"),UIImage(named: "home-1"), UIImage(named: "message-square") , UIImage(named: "alert-triangle"), UIImage(named: "log-out")] as! [UIImage]
        
                imageProfile.layer.borderColor = UIColor.red.cgColor
                self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2;
                self.imageProfile.clipsToBounds = true
        nameProfile.text = AppManager.shared.user?.firstName
        
        
            }
    
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return menuNameArray.count
            }
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Menu", for: indexPath) as? BarTableViewCell else {
                    return UITableViewCell()
                }
        
                cell.barImage.image = iconeImage[indexPath.row]
                cell.barLabel.text = menuNameArray[indexPath.row]
                //print(cell )
        
                return cell
        
            }
    
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             
                let revealViewController: SWRevealViewController = self.revealViewController()
                let cell: BarTableViewCell = tableView.cellForRow(at: indexPath) as! BarTableViewCell
                if cell.barLabel.text! == "Discovery"
                {
        
                    let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vs = mainStoryboard.instantiateViewController(withIdentifier: "HomeTabBarViewController") as! HomeTabBarViewController
                    let newFrontViewController = UINavigationController.init(rootViewController: vs)
                    revealViewController.pushFrontViewController(newFrontViewController, animated: true)
                    
                }
                if cell.barLabel.text! == "Booking"
                {
                    
                    let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vs = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    let newFrontViewController = UINavigationController.init(rootViewController: vs)
                    revealViewController.pushFrontViewController(newFrontViewController, animated: true)
                    
                }
        
                if cell.barLabel.text! == "Sign Out"
                {
        
                    loginServices?.oauth2.forgetTokens()
                    
                    loginServices?.oauth2.username    = nil
                    loginServices?.oauth2.password    = nil
                    
                    
                    print(  loginServices?.oauth2.accessToken ?? "")
                    let storage = HTTPCookieStorage.shared
                    storage.cookies?.forEach() {
                        storage.deleteCookie($0)
                        print(storage)
                    }
                    print("logout ")
                    UserDefaults.standard.set("", forKey: "Token")
                    UserDefaults.standard.setIsLoggedIn(value: false)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    present(vc, animated: true, completion: nil)
                }
                
                if cell.barLabel.text! == "Add Produit"
                {
                    let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vs = mainStoryboard.instantiateViewController(withIdentifier: "AjouterProduitViewController") as! AjouterProduitViewController
                    let newFrontViewController = UINavigationController.init(rootViewController: vs)
                    revealViewController.pushFrontViewController(newFrontViewController, animated: true)
                    
                
                }
                if cell.barLabel.text! == "Favorites"
                {
                    let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vs = mainStoryboard.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
                    let newFrontViewController = UINavigationController.init(rootViewController: vs)
                    revealViewController.pushFrontViewController(newFrontViewController, animated: true)
                }
                if cell.barLabel.text! == "Messages"
                {
                    let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vs = mainStoryboard.instantiateViewController(withIdentifier: "TestViewController") as! HomeController
                    let newFrontViewController = UINavigationController.init(rootViewController: vs)
                    revealViewController.pushFrontViewController(newFrontViewController, animated: true)
                    
                    
                }
                if cell.barLabel.text! == "Profile"
                {
                   
                    
                    if revealViewController != nil {
                        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
                        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vs = mainStoryboard.instantiateViewController(withIdentifier: "ProfilTabBarController")
                        let newFrontViewController = UINavigationController.init(rootViewController: vs)
                           revealViewController.pushFrontViewController(newFrontViewController, animated: true)
                        
                    }
                 
                    
                    
                }
        
            }
    
    
        }

