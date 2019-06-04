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

    func accepter(cell: LocationRequestCell) {
        
        guard let indexPathTapped = collectionView.indexPath(for: cell) else { return }
        let location =  locationList[indexPathTapped.row]


                updateLocationWithConfirmation(Id:  location.id! ,  userId: location.userId!, productId: location.productId!, duration: location.duration! , startDate: location.startDate!, endDate: location.endDate!, amount: location.amount!)
        responseImages.remove(at : indexPathTapped.row)
        locationList.remove(at: indexPathTapped.row)
        users.remove(at: indexPathTapped.row)
        collectionView.reloadData()

        
        }
    func delete(cell: LocationRequestCell) {
        
        guard let indexPathTapped = collectionView.indexPath(for: cell) else { return }
        let location =  locationList[indexPathTapped.row]
        self.deleteLocation(Id: location.id!)
        responseImages.remove(at : indexPathTapped.row)
        locationList.remove(at: indexPathTapped.row)
        users.remove(at: indexPathTapped.row)
        collectionView.reloadData()
        
        
    }
    func deleteLocation (Id : Int ) {
        
        
        let urlString = "https://clocation.azurewebsites.net/api/Location/\(Id)"
        
        AF.request(urlString, method: .delete,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            let favorite : String = "you really wanna delete this request"
            
            let alert = UIAlertController(title: "Alert", message: favorite, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (nil) in
                switch response.result {
                case .success:
                    print(response)
                    
                    
                    break
                case .failure(let error):
                    
                    print(error)
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "no", style: .default, handler: { (nil) in
                return
            }))
            
            self.present(alert, animated: true)
        }
    }
    func updateLocationWithConfirmation (Id : Int , userId : String ,productId : Int,duration : Int, startDate : String , endDate : String , amount : Decimal) {
    
        let params = ["id": Id ,  "userId": userId , "productId" : productId , "duration" : duration , "startDate" : startDate , "endDate" : endDate , "amount" : amount,  "isRequested" : true ,"isConfirmed" : true] as [String : Any]

        let urlString = "https://clocation.azurewebsites.net/api/Location/\(Id)"

        AF.request(urlString, method: .put, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            let favorite : String = "you wanna accept this request"

            let alert = UIAlertController(title: "Alert", message: favorite, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (nil) in
                switch response.result {
                case .success:
                    print(response)
                    
                    
                    break
                case .failure(let error):
                    
                    print(error)
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "no", style: .default, handler: { (nil) in
                return
            }))
            
            self.present(alert, animated: true)
  
           
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        produitList()
        UITabBar.appearance().barTintColor = UIColor.white
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
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
        let userDictionnary = UserDefaults.standard.dictionary(forKey: "userDictionnary")
        // print(userDictionnary?["name"]! as Any)
        
        let id = userDictionnary?["id"] as? String
        let urlString = urlRequestProductByUserId.url?.absoluteString
       // guard let userId = AppManager.shared.iduser else {return}
        let productURL = urlString! + id!
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
       
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd"
       let datedebut = formatter.date(from: locationList[index].endDate!)
        print(datedebut)
            let myStringafd = locationList[index].endDate
    
             let myStringadd = locationList[index].startDate
            cell.periodeLabel.text = "\(myStringafd ?? "") to \(myStringadd ?? "")"
            
        cell.nameProduit.text =  locationList[index].productName!
       
        if users.count > 0 {
        cell.telLabel.text = users[index].phoneNumber ?? "12345678"
        cell.userLabel.text = users[index].firstName
        }
         if responseImages.count > 0 {
        cell.imagePhoto.image = responseImages[index]
        }
       // cell.accepterButton.backgroundColor = UIColor.mainVerte
        if locationList[index].isConfirmed == true {
            cell.accepterButton.setTitle("Location Confirmed", for: .normal)
            cell.refuseButton.isHidden = true
            
            
        }
        if locationList[index].isConfirmed == false {
            cell.accepterButton.setTitle("Accept Location", for: .normal)
            cell.refuseButton.isHidden = false
            
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
        return CGSize.init(width: UIScreen.main.bounds.width - 5, height: 240)
    }
}



