//
//  WelcomeViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 07/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet var getStartedButton: UIButton!
    @IBOutlet var viewPurpel: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
            viewPurpel.roundCorners(corners: [.topLeft , .topRight], radius: 80.0)
        viewPurpel.roundCorners(corners: [.bottomLeft , .bottomRight], radius: 800.0)
        getStartedButton.roundCorners(corners: [.bottomLeft,.topLeft], radius: 800.0)
    
    }
    @IBAction func gotoButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        present(vc, animated: true, completion: nil)
    }
  

}

