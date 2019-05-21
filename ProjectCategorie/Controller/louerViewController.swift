//
//  louerViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 29/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
import Koyomi
struct expend  {
    var opened = Bool()
    var title =  String()
    //    var image = [UIImage]()
    var sectionData = [ProductClass]()
}
struct Disponibility {
    var startDate : String?
    var duration : Int?
}
class louerViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var product : ProductClass?
    var text : Int?
    var CurrentTableViewData = [expend]()
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
    var dispoList = [Disponibility]()
    var timer = Timer()
    var sectionTitle = ["detail of Produit", "Check disponibilté"]
    var counter = 0
    var attachementList = [Int]()
    var LocationList = [Location]()
    var LocationListDate = [String]()

    var responseImage = [UIImage]()
    var currentLocationList = [Location]()
    
    func tapped(cell: DisponibilteCell, sender: UISegmentedControl) {
        self.dispoList.removeAll()

        let month: MonthType = {
            switch sender.selectedSegmentIndex {
            case 0:  return .previous
            case 1:  return .current
            default: return .next
            }
        }()
        let dateFormatter = DateFormatter()
        var components = DateComponents()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        for dispo in dispoList {
            let date = dateFormatter.date(from: dispo.startDate ?? "")
            components.day = dispo.duration
            let range = Calendar.current.date(byAdding: components, to: date!)
            cell.koyomi.select(date: date!, to: range)

            
        }
        cell.koyomi.reloadData()
        cell.koyomi.display(in: month)


    }
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tableView.register(UINib( nibName: "DetailsProductCell", bundle: nil), forCellReuseIdentifier: "DetailsProductCell")
             self.tableView.register(UINib( nibName: "DisponibilteCell", bundle: nil), forCellReuseIdentifier: "DisponibilteCell")
        
        print("product id \(product?.id)")
//        sliderCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "sliderCell")

        print("product \(String(describing: product))")

        photos()
        getDateDisponible()
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
    
    func getDateDisponible () {
            guard let productId = product?.id else {return}
    let urlString = "http://clocation.azurewebsites.net/api/Location/AvailabilityInterval/\(productId)"
        
            AF.request(urlString, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in

                    do {
                        if let data = response.data {
                            let decoder = JSONDecoder()
                            let itemDetails1 = try decoder.decode([Location].self, from: data)
                            self.dispoList.removeAll()
                            for item1 in itemDetails1 {
                                
                                let dispo = Disponibility(startDate: item1.startDate, duration: item1.duration)
                                self.dispoList.append(dispo)
                                
                                
                                self.tableView.reloadData()
                            }
                          

                        }
                        
                    }catch let errords {
                        
                        print(errords)
                    }
    }
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

extension louerViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0 ){
            return 200
        }else{
            return 300
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     print( "self.dispoList \( self.dispoList)" )
      return 2
     
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0  ){
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsProductCell") as! DetailsProductCell
            if (product?.isAvailable == true){
                cell.uiswitch.isOn = true
            }
            else{
                cell.uiswitch.isOn = false
            }
            cell.nameDescriptionLabel.text = "produit name is : \( (product?.name)! + " descpription :" + (product?.description)!)"
            cell.prixUniteLabel.text = "prix : \(product?.price ?? 0)" + "$  /\(product?.enumUniteName ?? "Jour")"
            cell.cityRegionLabel.text = "city : \(product?.enumCityName ?? "") " + "/\(product?.address ?? "")"
            cell.telephoneLabel.text = "numero telephone is :\(AppManager.shared.user?.phoneNumber ?? "12345678")"
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DisponibilteCell") as! DisponibilteCell
            cell.tt = self
           let dateFormatter = DateFormatter()
            var components = DateComponents()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            for dispo in dispoList {
                 let date = dateFormatter.date(from: dispo.startDate ?? "")
                components.day = dispo.duration
                let range = Calendar.current.date(byAdding: components, to: date!)
                cell.koyomi.select(date: date!, to: range)
                
            }
     
        
            
            return cell
        }
        
     
    }
    
    func getDateFromString(dateStr: String) -> (Date?)
    {
        let calendar = Calendar(identifier: .gregorian)
        let dateComponentArray = dateStr.components(separatedBy: "-")
        
        if dateComponentArray.count == 3 {
            var components = DateComponents()
            components.year = Int(dateComponentArray[0])
            components.month = Int(dateComponentArray[1])
            components.day = Int(dateComponentArray[2])
            components.hour = Int(dateComponentArray[3])
            components.minute = Int(dateComponentArray[4])
//           components.timeZone = TimeZone(abbreviation: "GMT+0:00")
            guard let date = calendar.date(from: components) else {
                return (nil)
            }
            
            return (date)
        } else {
            return (nil)
        }
        
    }
    
}

//extension DisponibilteCell: KoyomiDelegate {
//    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
//        print("You Selected: \(date)")
//    }
//    
//    func koyomi(_ koyomi: Koyomi, currentDateString dateString: String) {
//        currentDateLabel.text = dateString
//    }
//    
//    
//    @objc(koyomi:shouldSelectDates:to:withPeriodLength:)
//    func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
//        
//        if length > invalidPeriodLength {
//            
//            print("More than \(invalidPeriodLength) days are invalid period.")
//            return false
//        }
//        return true
//    }
//}
