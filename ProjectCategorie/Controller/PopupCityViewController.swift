//
//  PopupCityViewController.swift
//  Projectcity
//
//  Created by MacBook Pro on 12/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
class PopupCityViewController: UIViewController {

    @IBOutlet var viewPopup: UIView!
    @IBOutlet var tableview: UITableView!
    var cityListNames = [String]()
    var cityList = [CityClass]()
    var urlRequest1 = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Region/City/")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Apply radius to Popupview
        viewPopup.layer.cornerRadius = 10
        viewPopup.layer.masksToBounds = true
        getcityNames()
        
    }
    func getcityNames() {
        let id : Int = Share.sharedName.RegionId ?? 1
        let urlString1 = self.urlRequest1.url?.absoluteString
        let url = urlString1!+"\(id )"
        
        AF.request(url , method : .get).responseJSON {
            response in
            do {
                
                if let data = response.data {
                    let itemDetails1 = try JSONDecoder().decode([CityClass].self, from: data)
                    for item1 in itemDetails1 {
                        self.cityListNames.append(item1.name ?? "")
                        self.cityList.append(item1)
                    }
                    
                    print("souscitysListNames after append \(self.cityListNames)")
                    
                    self.tableview.reloadData()
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
extension PopupCityViewController : UITableViewDataSource , UITableViewDelegate {
    // Returns count of items in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityList.count
    }
    // Select item from tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("CITY Name : " + cityList[indexPath.row].name!)
        
        Share.sharedName.CityName = cityList[indexPath.row].name
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AjouterProduitViewController") as! AjouterProduitViewController
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    //Assign values for tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellcity", for: indexPath)
        
        cell.textLabel?.text = cityList[indexPath.row].name
        
        return cell
    }
    
    
}
