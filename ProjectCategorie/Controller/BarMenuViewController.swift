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
    
    @IBOutlet var labelSignOut: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuNameArray = ["Profile" , "Discovery" ,  "Add Produit" ,"Booking"  , "Messages" , "Favorites"]
        iconeImage = [UIImage(named: "user-check-2") , UIImage(named: "search") ,UIImage(named: "edit"),UIImage(named: "home-1"), UIImage(named: "message-square") , UIImage(named: "alert-triangle")] as! [UIImage]
        
        imageProfile.layer.borderColor = UIColor.red.cgColor
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2;
        self.imageProfile.clipsToBounds = true
        nameProfile.text = AppManager.shared.user?.firstName
        tableViews.rowHeight = 55
        labelSignOut.isUserInteractionEnabled = true
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BarMenuViewController.tapFunction))
       
        labelSignOut.addGestureRecognizer(tapGesture)
    }
    
    
  @objc func tapFunction() {
        print("tap working")
        loginServices?.oauth2.forgetTokens()
        
        loginServices?.oauth2.username    = nil
        loginServices?.oauth2.password    = nil
        
//    if AppManager.shared.iduser != nil {
//
//        
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController")
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let nc = UINavigationController(rootViewController: vc)
//            nc.isNavigationBarHidden = true
//            appDelegate.window?.rootViewController = nc
//        
//    }
    UserDefaults.standard.set(nil, forKey: "idCurrentUser")
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    let vc = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let nc = UINavigationController(rootViewController: vc)
    nc.isNavigationBarHidden = true
    appDelegate.window?.rootViewController = nc

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
            
            
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vs = mainStoryboard.instantiateViewController(withIdentifier: "ProfilTabBarController")
            let newFrontViewController = UINavigationController.init(rootViewController: vs)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
            
        }
        
        
        
    }
    
    
}

