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

   
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
var users = [User]()
    var locationList = [Location]()
       var urlRequestProductByUserId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Location/RequestedLocation/")!)
    var urlRequestAttachmentsId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    var urlRequestImageByAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Users/")!)
    var responseImages = [UIImage]()
    var attachementListId = [Int]()
    let cellSpacingHeight: CGFloat = 20
//    var twoDimensionalArray = [Location]()

    func someMethodIWantToCall(cell: LocationRequestCell) {
        
        guard let indexPathTapped = collectionView.indexPath(for: cell) else { return }
        let location =  locationList[indexPathTapped.row]
//
//            let hasconfirme = location.isConfirmed
//           location.isConfirmed = !hasconfirme!
//            cell.accepterButton.tintColor = hasconfirme! ?  UIColor.lightGray : .red
//        cell.accepterButton.setImage(hasconfirme! ?  UIImage(named: "checkrouge") : UIImage(named: "checkvert") , for: .normal)
//            if (hasconfirme == false) {
                updateLocationWithConfirmation(Id:  location.id! ,  userId: location.userId!, productId: location.productId!, duration: location.duration! , startDate: location.startDate!, endDate: location.endDate!, amount: location.amount!)
        collectionView.reloadData()

        
        }
    func updateLocationWithConfirmation (Id : Int , userId : String ,productId : Int,duration : Int, startDate : String , endDate : String , amount : Decimal) {
    
        let params = ["id": Id ,  "userId": userId , "productId" : productId , "duration" : duration , "startDate" : startDate , "endDate" : endDate , "amount" : amount,  "isRequested" : true ,"isConfirmed" : true] as [String : Any]

        let urlString = "https://clocation.azurewebsites.net/api/Location/\(Id)"

        AF.request(urlString, method: .put, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in

                print(response)
                let favorite : String = "vous avez accepeter ce demande "
                self.displayMessage(userMessage: favorite)

           
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        produitList()
         self.collectionView.register(UINib( nibName: "LocationRequestCell", bundle: nil), forCellWithReuseIdentifier: "LocationRequestCell")
        
        activityIndicator.startAnimating()

    }
    func getUserInformation (id : String) {
        let urlString = urlRequest.url?.absoluteString
        let URL = urlString! + "\(id)"
        AF.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            guard let data = response.data else {return}
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                AppManager.shared.user = user
                print(user.id)
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                self.users.append(user)

                
            }catch let err {
                print(err)
            }
        }
    }
    func searchImage(productId : Int) {
        
        let urlStringImageByAttachmentId = urlRequestImageByAttachmentId.url?.absoluteString
        let attachementURL = urlStringImageByAttachmentId! + "\(productId)/ImageByProductId"
        
        AF.request(attachementURL , method : .get ).responseImage {
            response in
            guard let image = response.data else {return}
            print(image)
            self.responseImages.append( UIImage(data: image) ?? UIImage(named: "EmmaStone")!)
            self.collectionView.reloadData()
      
        }
    }
    func produitList() {
        
        let urlString = urlRequestProductByUserId.url?.absoluteString
        //guard let userId = AppManager.shared.iduser else {return}
        let productURL = urlString! + "5db395d9-3b02-4c27-bb19-0f4c6ce8b851"
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

               
                    guard let productId = item.productId else {return}
                    guard let userId = item.userId else {return}
                    self.getUserInformation(id: userId)
                    self.searchImage(productId: productId)
                    print(productId)
                    self.collectionView.reloadData()

                    
                }
                self.collectionView.reloadData()
                
                
            }catch let errors {
                print(errors)
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        
    }

 
        
    
    
}

extension LocationRequestedController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responseImages.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationRequestCell", for: indexPath) as! LocationRequestCell

        let index = indexPath.row
        cell.linkto = self
       // cell.amountLabel.text = "le prix : \(locationList[index].amount!) $"
        if locationList.count > 0 {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "dd-MMM-yyyy"
            // again convert your date to string
            let myStringafd = formatter.date(from: locationList[index].endDate ?? "")
             let myStringadd = formatter.date(from: locationList[index].startDate ?? "")
             cell.periodeLabel.text = "\(myStringafd ?? Date())  \n  to \(myStringadd ?? Date())"
            
        cell.nameProduit.text =  locationList[index].productName!
        }
        if users.count > 0 {
        cell.telLabel.text = users[index].phoneNumber
        cell.userLabel.text = users[index].firstName
        }
         if responseImages.count > 0 {
        cell.imagePhoto.image = responseImages[index]
        }
        if locationList[index].isConfirmed == true {
            cell.accepterButton.backgroundColor = UIColor.green
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
// extention for UICollectionViewDelegateFlowLayout
extension LocationRequestedController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = 10
        return UIEdgeInsets(top: CGFloat(inset), left: CGFloat(inset), bottom: CGFloat(inset), right: CGFloat(inset))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width - 5, height: 232)
    }
}



