//
//  PopupRegionViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 12/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
class PopupRegionViewController: UIViewController {

    @IBOutlet var viewPopup: UIView!
    @IBOutlet var tableView: UITableView!
    var RegionListNames = [String]()
    var RegionList = [RegionClass]()
    
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/EnumRegion")!)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Apply radius to Popupview
        viewPopup.layer.cornerRadius = 10
        viewPopup.layer.masksToBounds = true
        getRegionNames()
        
    }
    
    func getRegionNames(){
        
        let urlString = urlRequest.url?.absoluteString
        AF.request(urlString! , method : .get).responseJSON {
            
            response in
            do {
                if let data = response.data {
                    let itemDetails1 = try JSONDecoder().decode([RegionClass].self, from: data)
                    for item1 in itemDetails1 {
                        self.RegionListNames.append(item1.name ?? "")
                        
                        self.RegionList.append(item1)
                    }
                    self.tableView.reloadData()
                }
            }catch let errords {
                
                print(errords)
            }
            
        }
    }


    @IBAction func cancelButton(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }


}
extension PopupRegionViewController : UITableViewDelegate , UITableViewDataSource {
    // Returns count of items in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.RegionList.count
    }
    // Select item from tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("region Name : " + RegionList[indexPath.row].name!)
        Share.sharedName.RegionName = RegionList[indexPath.row].name
        Share.sharedName.RegionId = RegionList[indexPath.row].id
//        if indexPath.section == 0 {
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "PopupCityViewController") as! PopupCityViewController
//            self.present(newViewController, animated: true, completion: nil)
////        }

       dismiss(animated: true, completion: nil)
//        
        
    }
    
    //Assign values for tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellregion", for: indexPath)
        cell.textLabel?.text = RegionList[indexPath.row].name
        return cell
    }
    
}
