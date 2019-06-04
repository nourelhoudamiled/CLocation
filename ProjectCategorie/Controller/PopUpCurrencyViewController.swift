//
//  PopUpCurrencyViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 03/06/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
class PopUpCurrencyViewController: UIViewController {

    @IBOutlet var viewPop: UIView!
    @IBOutlet var tableView: UITableView!
    var CurrencyListNames = [String]()
    var CurrencyList = [Currency]()
    
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/EnumCurrency")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Apply radius to Popupview
        viewPop.layer.cornerRadius = 10
        viewPop.layer.masksToBounds = true
        getCurencyNames()

      
    }
    func getCurencyNames(){
        let urlString = urlRequest.url?.absoluteString
        AF.request(urlString!, method: .get ,parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                do {
                    if let data = response.data {
                        let itemDetails1 = try JSONDecoder().decode([Currency].self, from: data)
                        for item1 in itemDetails1 {
                            self.CurrencyListNames.append(item1.name )
                            self.CurrencyList.append(item1)
                        }
                        self.tableView.reloadData()
                    }
                    
                }catch let errords {
                    
                    print(errords)
                }
        }
    }
    
    @IBAction func cancelButtin(_ sender: Any) {
          dismiss(animated: true, completion: nil)
    }
    

}
extension PopUpCurrencyViewController : UITableViewDelegate , UITableViewDataSource {
    // Returns count of items in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.CurrencyList.count
    }
    // Select item from tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        Share.sharedName.currencyId = CurrencyList[indexPath.row].id
        Share.sharedName.currencySymbol = CurrencyList[indexPath.row].symbol

        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    //Assign values for tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = CurrencyList[indexPath.row].id
        cell.detailTextLabel?.text = CurrencyList[indexPath.row].symbol

        
        return cell
    }
    
}
