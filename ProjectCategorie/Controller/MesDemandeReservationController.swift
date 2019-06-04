//
//  MesDemandeReservationController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 10/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
class MesDemandeReservationController: UIViewController {
    var urlRequestImageByAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    var urlRequestUserLocation = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Location/User/")!)
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var responseImages = [UIImage]()
    var locationList = [Location]()
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        produitList()
        self.collectionView.register(UINib( nibName: "MesDemandeCell", bundle: nil), forCellWithReuseIdentifier: "MesDemandeCell")
        activityIndicator.startAnimating()
        
    }
    func searchImage(productId : Int) {
        
        let urlStringImageByAttachmentId = urlRequestImageByAttachmentId.url?.absoluteString
        let attachementURL = urlStringImageByAttachmentId! + "\(productId)/ImageByProductId"
        
        AF.request(attachementURL , method : .get ).responseImage {
            response in
            guard let image = response.data else {return}
            print(image)
            self.responseImages.append( UIImage(data: image) ?? UIImage(named: "Agricole")!)
            self.collectionView.reloadData()
        }
    }
    func produitList() {
        let userDictionnary = UserDefaults.standard.dictionary(forKey: "userDictionnary")        
        let id = userDictionnary?["id"] as? String
        let urlString = urlRequestUserLocation.url?.absoluteString
        //   guard let userId = AppManager.shared.iduser else {return}
        let productURL = urlString! + id!
        //  print("useriD : \(userId)")
        AF.request(productURL , method : .get).responseJSON {
            response in
            do {
                print("response \(response)")
                guard let data = response.data else {return}
                let itemDetails = try JSONDecoder().decode([Location].self, from: data)
                print("item detaile \(itemDetails)")
                self.locationList.removeAll()
                for item  in itemDetails {
                    self.locationList.append(item)
                    guard let productId = item.productId else {return}
                    self.searchImage(productId: productId)
                    print(productId)
                    //    self.collectionView.reloadData()
                    
                }
                // self.collectionView.reloadData()
                
                
            }catch let errors {
                print(errors)
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        
    }
    
}

extension MesDemandeReservationController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responseImages.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MesDemandeCell", for: indexPath) as! MesDemandeCell
        let index = indexPath.row
        cell.index = indexPath
        cell.delegate = self 
        
        if locationList.count > 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let myStringafd = locationList[index].startDate
            let myStringadd = locationList[index].endDate
            cell.durrationLabel.text = "\(locationList[index].duration ?? 0)"
            cell.totaleLabel.text = "\(locationList[index].amount ?? 0)"

            cell.periodLabel.text = "\(myStringafd ?? "") to \(myStringadd ?? "")"
            cell.nameProduit.text =  locationList[index].productName!
            cell.requestButton.isEnabled = true
            if locationList[index].isConfirmed == true {
                cell.requestButton.setTitle("Location Confirmed", for: .normal)
                cell.requestButton.backgroundColor = UIColor.mainVerte
                cell.cancelButton.isHidden = true
                
                
            }
            if locationList[index].isConfirmed == false {
                cell.requestButton.setTitle("Request Pending", for: .normal)
                cell.requestButton.backgroundColor = UIColor.mainGray
                cell.cancelButton.isHidden = false
                
            }
        }
        if responseImages.count > 0 {
            cell.imageProduit.image = responseImages[index]
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
extension MesDemandeReservationController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = 10
        return UIEdgeInsets(top: CGFloat(inset), left: CGFloat(inset), bottom: CGFloat(inset), right: CGFloat(inset))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: 210)
    }
}

extension MesDemandeReservationController : MesDemandeReservationProtocol {
    func deleteData(indx: Int) {
        deleteDemande(Id: locationList[indx].id!)
        responseImages.remove(at : indx)
        locationList.remove(at: indx)
        
        collectionView.reloadData()
    }
    func deleteDemande (Id : Int ) {
        
        
        let urlString = "https://clocation.azurewebsites.net//api/Location/\(Id)"
        
        AF.request(urlString, method: .delete,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            print(response)
        self.displayMessageOui(userMessage: "you want to delete this request ")
        }
    }
}
