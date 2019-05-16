//
//  LocationRequestedController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 10/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
class LocationRequestedController: UIViewController {

   
    @IBOutlet var tableView: UITableView!
    var locationList = [Location]()
       var urlRequestProductByUserId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Location/RequestedLocation/")!)
    var urlRequestAttachmentsId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    var urlRequestImageByAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    var responseImages = [UIImage]()
    var attachementListId = [Int]()
    let cellSpacingHeight: CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()
      //  photos(productId: 236)
        produitList()
        tableView.rowHeight = 300
      //  tableView.estimatedRowHeight = 223

    }
    func searchImage(productId : Int) {
        
        let urlStringImageByAttachmentId = urlRequestImageByAttachmentId.url?.absoluteString
        let attachementURL = urlStringImageByAttachmentId! + "\(productId)/ImageByProductId"
        
        AF.request(attachementURL , method : .get ).responseImage {
            response in
            guard let image = response.data else {return}
            print(image)
            self.responseImages.append( UIImage(data: image) ?? UIImage(named: "Maisson")!)
            self.tableView.reloadData()
        }
    }
    func produitList() {
    
        let urlString = urlRequestProductByUserId.url?.absoluteString
        guard let userId = AppManager.shared.iduser else {return}
        let productURL = urlString! + "\(userId)"
        print("useriD : \(userId)")
        
        AF.request(productURL , method : .get).responseJSON {
            response in
            do {
                print("response \(response)")

                guard let data = response.data else {return}
                let itemDetails = try JSONDecoder().decode([Location].self, from: data)
                print("item detaile \(itemDetails)")
                for item  in itemDetails {
                    self.locationList.append(item)
                    guard let productId = item.productId else {return}
                    self.searchImage(productId: productId)
                    print(productId)

                }
                self.tableView.reloadData()

               
            }catch let errors {
                print(errors)
            }
            
        }
        
        
        
        
    }

 
        
    
    
}
extension LocationRequestedController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseImages.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestCell

        let index = indexPath.row
        cell.amountLabel.text = "\(locationList[index].amount!)"
        cell.dateFin.text = locationList[index].endDate
        cell.dateDebut.text = locationList[index].startDate
        cell.nameProduit.text = locationList[index].productName
        cell.imageProduit.image = responseImages[index]
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.backgroundColor = UIColor.white
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    
}

