//
//  ProfilTabBarController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 07/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ProfilTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))

        }
    }
    

 

}