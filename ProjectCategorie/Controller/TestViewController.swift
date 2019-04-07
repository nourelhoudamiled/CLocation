//
//  TestViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 04/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
class TestViewController: UIViewController {

    @IBOutlet var nameText: SkyFloatingLabelTextField!
    @IBOutlet var idText: SkyFloatingLabelTextField!
 
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            
            
            
        }
        
    }
    
    @IBAction func testButton(_ sender: Any) {
         /************** Get / id ***************/
        let value = idText.text!
        let rewardInt = Int(value)
        getUniteRequest(byId: rewardInt! ) { (tweetRequest) in
            print(tweetRequest ?? "")

        
       
        
      
        }
    }
        
        
        //$$$$$$$$ delete $$$$$$$$$$
        //             let value = idUniteTextField.text!
        //                let rewardInt = Int(value)
        //            deleteRequest(byId: rewardInt! ) { (tweetRequest) in
        //            print(tweetRequest)
    }
func getUniteRequest(byId Id: Int, completion: @escaping (Unite?) -> Void) {
    let urlString = "https://clocation.azurewebsites.net/api/EnumUnite/\(Id)"
    AF.request(urlString).response { response in
        guard let data = response.data else { return }
        do {
            let decoder = JSONDecoder()
            let Request = try decoder.decode(Unite.self, from: data)
            print(Request)
            print(Request.id!)
        } catch let error {
            print(error)
            completion(nil)
        }
    }
}
    func deleteRequest(byId Id: Int, completion: @escaping (Bool) -> Void) {
        let urlString = "https://clocation.azurewebsites.net/api/EnumUnite/\(Id)"
        AF.request(urlString, method: .delete).responseString { response in
            completion((response.value != nil))
            //print(response.result.isSuccess)
        }
    }


/************** Post ***************/
//                let urlString = "https://clocation.azurewebsites.net/api/EnumUnite"
//
//                AF.request(urlString, method: .post, parameters: ["name": nameText.text!],encoding: JSONEncoding.default, headers: nil).responseJSON {
//                    response in
//
//            switch response.result {
//            case .success:
//            print(response)
//
//            break
//            case .failure(let error):
//
//            print(error)
//            }
//                }

