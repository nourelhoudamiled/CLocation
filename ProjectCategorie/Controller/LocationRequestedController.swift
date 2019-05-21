//
//  LocationRequestedController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 10/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
//struct Confirme {
//
//    var locations: Location?
//    var hasconfirme : Bool?
//}
class LocationRequestedController: UIViewController {

   
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    var locationList = [Location]()
       var urlRequestProductByUserId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Location/RequestedLocation/")!)
    var urlRequestAttachmentsId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    var urlRequestImageByAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    var responseImages = [UIImage]()
    var attachementListId = [Int]()
    let cellSpacingHeight: CGFloat = 20
//    var twoDimensionalArray = [Location]()

    func someMethodIWantToCall(cell: RequestCell) {
        
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        var location =  locationList[indexPathTapped.row]

            let hasconfirme = location.isConfirmed
           location.isConfirmed = !hasconfirme!
            cell.confirmeButton.tintColor = hasconfirme! ?  UIColor.lightGray : .red
        cell.confirmeButton.setImage(hasconfirme! ?  UIImage(named: "fav_star") : UIImage(named: "del") , for: .normal)
            if (hasconfirme == false) {
                updateLocationWithConfirmation(Id:  location.id ?? 0 ,  userId: location.userId ?? "", productId: location.productId ?? 0, duration: location.duration ?? 0 , startDate: location.startDate ?? "", endDate: location.endDate ?? "", amount: location.amount ?? 0.0, isRequested: false, isConfirmed: true)
//                self.postFavorite(Id: ProductList[indexPathTapped.row].id!, userId: "5db395d9-3b02-4c27-bb19-0f4c6ce8b851")
            }
        
  
         print(hasconfirme)
    }
    func updateLocationWithConfirmation (Id : Int , userId : String ,productId : Int,duration : Int, startDate : String , endDate : String , amount : Decimal , isRequested : Bool , isConfirmed : Bool) {
    
        let params = ["id": Id ,  "userId": userId , "productId" : productId , "duration" : duration , "startDate" : startDate , "endDate" : endDate , "amount" : amount,  "isRequested" : false ,"isConfirmed" : true] as [String : Any]

        let urlString = "https://clocation.azurewebsites.net/api/Location/\(Id)"

        AF.request(urlString, method: .put, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in

            switch response.result {
            case .success:
                print(response)
                let favorite : String = "vous avez accepeter ce demande "
                self.displayMessage(userMessage: favorite)

                break
            case .failure(let error):

                print(error)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
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
            self.responseImages.append( UIImage(data: image) ?? UIImage(named: "EmmaStone")!)
            self.tableView.reloadData()
        }
    }
    func produitList() {
        
        let urlString = urlRequestProductByUserId.url?.absoluteString
        //guard let userId = AppManager.shared.iduser else {return}
        let productURL = urlString! + "83a22f90-ef02-40bc-971e-2cda1296bf01"
       // print("useriD : \(userId)")
        
        AF.request(productURL , method : .get).responseJSON {
            response in
            do {
                print("response \(response)")
                
                guard let data = response.data else {return}
                let itemDetails = try JSONDecoder().decode([Location].self, from: data)

                print("item detaile \(itemDetails)")
                for item  in itemDetails {
                    self.locationList.append(item)
                   // print(item.isConfirmed)
//                    self.twoDimensionalArray.append(Confirme(locations: item))

//                    if (item.isConfirmed == true)
//                    {
//
////                        self.twoDimensionalArray.append(Confirme(locations: item, hasconfirme: true))
//                        self.tableView.reloadData()
//
//                    }
                    guard let productId = item.productId else {return}
                    self.searchImage(productId: productId)
                    print(productId)
                    self.tableView.reloadData()

                    
                }
                self.tableView.reloadData()
                
                
            }catch let errors {
                print(errors)
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
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
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestCell

        let index = indexPath.row
        cell.linkto = self
        cell.amountLabel.text = "le prix : \(locationList[index].amount!) $"
//        cell.dateFin.text = " date fin : " + locationList[index].endDate!
//        cell.dateDebut.text = " date debut : " + locationList[index].startDate!
        cell.nameProduit.text = " name of product : " + locationList[index].productName!
        cell.imageProduit.image = responseImages[index]
            if locationList[index].isConfirmed == true {
                cell.confirmeButton.tintColor = UIColor.red
            }
            else
            {
                cell.confirmeButton.tintColor =  UIColor.lightGray
            }
  
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

