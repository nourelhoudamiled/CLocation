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

    override func viewDidLoad() {
        super.viewDidLoad()
        produitList()

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
                    guard let productId = item.id else {return}
                    self.photoList(productId: productId)
                    // self.collectionView.reloadData()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print(productId)
                }
                print(self.locationList.count)
               
            }catch let errors {
                print(errors)
            }
            
        }
        
        
        
        
    }
    func photoList(productId: Int){
    
        let urlStringAttachmentsId = urlRequestAttachmentsId.url?.absoluteString
        let urlStringImageByAttachmentId = urlRequestImageByAttachmentId.url?.absoluteString
        let attachementsURL = urlStringAttachmentsId! + "\(productId)/AttachmentsId"
        AF.request(attachementsURL).responseJSON {
            response in
            do {
                guard let data = response.data else {return}
                let attachements = try JSONDecoder().decode([Attachement].self, from: data)
                for atachement in attachements {
                    self.attachementListId.append(atachement.id!)
                    guard let  attachementId = atachement.id else {return}
                    let AttachmentIdURL = urlStringImageByAttachmentId! + "\(attachementId)/ImageByAttachmentId"
                    
                    AF.request(AttachmentIdURL , method : .get ).responseImage {
                        response in
                        guard let image = response.data else {return}
                        print(image)
                        guard let photo =  UIImage(data: image) else {return}
                        self.responseImages.append(photo)
                        // self.collectionView.reloadData()
                    }
                    print("responseImages.count\(self.responseImages.count)")
                    
                }
                
                
            }catch let error {
                print(error)
            }
            
        }
        
        
        }
        
    
    
}
extension LocationRequestedController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestCell
        let index = indexPath.row
        cell.amountLabel.text = "\(locationList[index].amount)"
        cell.dateFin.text = "\(locationList[index].endDate)"
        cell.dateDebut.text = "\(locationList[index].startDate)"
        cell.nameProduit.text = locationList[index].productName
        return cell
    }
    
}
extension LocationRequestedController : UICollectionViewDataSource , UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  responseImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequestCollectionCell", for: indexPath) as! RequestCollectionCell
        let index = indexPath.row

        cell.imageProduit.image = responseImages[index]
        return cell

    }

}
