//
//  louerViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 29/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
class louerViewController: UIViewController {
    
    var product : ProductClass?
    var text : Int?

    @IBOutlet var nameUniteLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var prixLabel: UILabel!
    @IBOutlet var isAvailble: UISwitch!
    @IBOutlet var telLabel: UILabel!
    @IBOutlet var adrLabel: UILabel!
    @IBOutlet var pageView: UIPageControl!
    @IBOutlet var sliderCollectionView: UICollectionView!
  

    var urlRequestImageByAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    
    //   @IBOutlet var downloadImage: UIImageView!
    var urlRequestAttachmentsId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)

    var imgArr = [  UIImage(named:"AlexandraDaddario"),
                    UIImage(named:"AngelinaJolie") ,
                    UIImage(named:"AnneHathaway") ,
                    UIImage(named:"DakotaJohnson") ,
                    UIImage(named:"EmmaStone") ,
                    UIImage(named:"EmmaWatson") ,
                    UIImage(named:"HalleBerry") ,
                    UIImage(named:"JenniferLawrence") ,
                    UIImage(named:"JessicaAlba") ,
                    UIImage(named:"ScarlettJohansson") ]
    
    var timer = Timer()
    var counter = 0
    var attachementList = [Int]()
    var responseImage = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("product id \(product?.id)")
//        sliderCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "sliderCell")

        print("product \(String(describing: product))")
        nameUniteLabel.text = product?.enumUniteName
        cityLabel.text = product?.enumCityName
        descriptionLabel.text =  (product?.name)! + "\n\n" + (product?.description)!
      
        prixLabel.text =  "\(product?.price ?? 0)"
        
     
        
        adrLabel.text = product?.address
        if (product?.isAvailable == true){
            isAvailble.isOn = true
        }
        else{
           isAvailble.isOn = false
        }
 photos()
        pageView.numberOfPages = responseImage.count
//        pageView.currentPage = 0
       
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func photos(){
        let urlStringAttachmentsId = urlRequestAttachmentsId.url?.absoluteString
        let urlStringImageByAttachmentId = urlRequestImageByAttachmentId.url?.absoluteString
        let productId = Share.sharedName.product?.id
        let attachementsURL = urlStringAttachmentsId! + "\(productId!)/AttachmentsId"
        AF.request(attachementsURL).responseJSON {
            response in
            do {
                guard let data = response.data else {return}
                let attachements = try JSONDecoder().decode([Attachement].self, from: data)
                for atachement in attachements {
                    self.attachementList.append(atachement.id!)
                    guard let  attachementId = atachement.id else {return}
                    let AttachmentIdURL = urlStringImageByAttachmentId! + "\(attachementId)/ImageByAttachmentId"

                    AF.request(AttachmentIdURL , method : .get ).responseImage {
                        response in
                        guard let image = response.data else {return}
                        print(image)
                        self.responseImage.append( UIImage(data: image) ?? UIImage(named: "pot-1")! )
                        self.sliderCollectionView.reloadData()
                        
                    }
                }
                
                
            }catch let error {
                print(error)
            }
            
        }
        
        
    }
    @objc func changeImage() {
        
        if counter < responseImage.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
    
    }
    
    @IBAction func reservationButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReservationViewController") as! ReservationViewController
        
        present(vc, animated: true, completion: nil)
    }
    @IBAction func Gotocommentaire(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentaireViewController") as! CommentaireViewController
        
        present(vc, animated: true, completion: nil)
    }
    
}

extension louerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responseImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! sliderCell
        
            cell.imageSlider.image = responseImage[indexPath.row]
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
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

extension louerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
