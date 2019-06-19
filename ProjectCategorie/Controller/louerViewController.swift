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
import FSCalendar
struct expend  {
    var opened = Bool()
    var title =  String()
    //    var image = [UIImage]()
  //  var sectionData = [String]()
}

class louerViewController: UIViewController {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var urlRequestSearchRating = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Product/Rating/")!)
    @IBOutlet var cosmosView: CosmosView!
    @IBOutlet var labelName: UILabel!
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
    
    var urlRequestAttachmentsId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)

    var dispoList = [Disponibility]()
    var timer = Timer()
    var counter = 0
    var attachementList = [Int]()
    var LocationList = [Location]()
    var LocationListDate = [String]()

    var responseImage = [UIImage]()
    var currentLocationList = [Location]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        photos()
        
                labelName.text = product?.name
        searchRating(productId: (product?.id)!)
         self.tableView.register(UINib( nibName: "DetailsProductCell", bundle: nil), forCellReuseIdentifier: "DetailsProductCell")
         self.tableView.register(UINib( nibName: "DetailOfUserCell", bundle: nil), forCellReuseIdentifier: "DetailOfUserCell")
             self.tableView.register(UINib( nibName: "DisponibilteCell", bundle: nil), forCellReuseIdentifier: "DisponibilteCell")
         self.tableView.register(UINib( nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        getDateDisponible()
        CurrentTableViewData = [expend(opened: false, title: "product Detail"), expend(opened: false, title: "availability"), expend(opened: false, title: "Lessee’s details" ) ]
    }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()

       

      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchRating (productId : Int) {
        
        let urlStringSearchRating = urlRequestSearchRating.url?.absoluteString
        let SearchRatingURL = urlStringSearchRating! + "\(productId)"
        
        AF.request(SearchRatingURL , method : .get).responseJSON {
            response in
            
            guard let data = response.data else {return}
            var notevalue = String(data: data, encoding: .utf8)!
            if notevalue == "\"NaN\"" {
                notevalue = "0"
            }
            self.cosmosView.rating = Double(notevalue) ?? 0
           
            
        }
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
                            for item1 in itemDetails1 {
                                
                                let dispo = Disponibility(startDate: item1.startDate, duration: item1.duration , endDate: item1.endDate)
                                self.dispoList.append(dispo)
                                
                                
                                self.tableView.reloadData()
                            }
                          

                        }
                        
                    }catch let errords {
                        
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
                        self.responseImage.append( UIImage(data: image) ?? UIImage(named: "pot-1")! )
                        self.sliderCollectionView.reloadData()
                        
                    }
                }
                
                self.pageView.currentPage = 0
                self.pageView.numberOfPages = self.responseImage.count
                DispatchQueue.main.async {
                    self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
                }
                
                
            }catch let error {
//
                
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        
        
    }
    @objc func changeImage() {
        
        if counter < responseImage.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        }
        else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
    
    }
    
    @IBAction func reservationButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReservationViewController") as! ReservationViewController
        vc.product =  product
       // Share.sharedName.product =  ProductList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func Gotocommentaire(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentaireViewController") as! CommentaireViewController
        Share.sharedName.product =  product
        self.navigationController?.pushViewController(vc, animated: true)

        
    }
    
}

extension louerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responseImage.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! sliderCell
        if (responseImage.count > indexPath.row ) {
            cell.imageSlider.image = responseImage[indexPath.row]
        }
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
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
            return 50
        }else{
             if (indexPath.section == 1) {
            return 300 
            }
            return 230
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if CurrentTableViewData[indexPath.section].opened == true {
                CurrentTableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer : indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }else{
                CurrentTableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer : indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     print( "self.dispoList \( self.dispoList)" )
    
            
            if CurrentTableViewData[section].opened == true
            {
                return 2
                
            }else {
                return 1
            }
            
     
    }
    func numberOfSections(in tableView: UITableView) -> Int {
 return CurrentTableViewData.count
        
    }
//    public func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return section == 0 ? DateModel.dayCountPerRow : DateModel.maxCellCount
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if(indexPath.section == 0  ){
            if indexPath.row == 0 {
  let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
                cell.titleLabel.text = CurrentTableViewData[indexPath.section].title
                cell.viewCell.layer.borderWidth = 1.0
                cell.viewCell.layer.borderColor = UIColor.gray.cgColor
               cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none
                return cell
            }
            else
            {
                if (indexPath.section == 0) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsProductCell") as! DetailsProductCell

                    cell.nameDescriptionLabel.text = product?.description
                    cell.prixUniteLabel.text = "\(product?.price ?? 0)" + "DT  /\(product?.enumUniteName ?? "Jour")"
                    cell.cityRegionLabel.text = "\(product?.enumCityName ?? "") " + "/\(product?.address ?? "")"
                    cell.telephoneLabel.text = "Neuf"
                    cell.selectionStyle = .none

                       return cell
                }
                if (indexPath.section == 1 ) {
                 
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DisponibilteCell") as! DisponibilteCell
                    cell.tt = self
                    cell.fsCalendar.delegate  = self
                    cell.fsCalendar.dataSource = self
//                    let dateFormatter = DateFormatter()
//                    var components = DateComponents()
//                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//
//                    for dispo in dispoList {
//                        let date = dateFormatter.date(from: dispo.startDate ?? "")
//                        components.day = dispo.duration
//                        let range = Calendar.current.date(byAdding: components, to: date!)
//
//
//                    }
                    cell.selectionStyle = .none
                    
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DetailOfUserCell") as! DetailOfUserCell
                    let userDictionnary = UserDefaults.standard.dictionary(forKey: "userDictionnary")
                    let name = userDictionnary?["firstName"] as? String
                    let phoneNumber = userDictionnary?["phoneNumber"] as? String
                    let facebookUrl = userDictionnary?["facebookUrl"] as? String
                    cell.nameUserLabel.text = "alice"
                    cell.phoneNumberLabel.text =  "98100200"
                    cell.cityLabel.text = "je suis un spécialte de vente et location"
                    cell.selectionStyle = .none
                    
                    return cell

                   
                }
                
            }


        
     
    }

    
}

extension louerViewController :  FSCalendarDelegate , FSCalendarDataSource , FSCalendarDelegateAppearance  {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        let dateFormatter = DateFormatter()
        var components = DateComponents()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        for dispo in dispoList {
            let dateT = dateFormatter.date(from: dispo.startDate ?? "")
            let dateF = dateFormatter.date(from: dispo.endDate ?? "")
            
            let calendar = NSCalendar.current
            let normalizedStartDate = calendar.startOfDay(for: dateT!)
            let normalizedEndDate = calendar.startOfDay(for: dateF!)
            var dates: [Date] = []
            var currentDate = normalizedStartDate
            repeat {
                currentDate =  calendar.date(byAdding: .day, value: 1, to: currentDate)!
                dates.append(currentDate)
            } while !calendar.isDate(currentDate, inSameDayAs: normalizedEndDate)
            print(dates)
          
            
            for d in dates {
                if date == d {
                    return .blue
                }
            }
            
            
                    }
        
       return .white
    }
}
