//
//  ReservationViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 10/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
class ReservationViewController: UIViewController {

    @IBOutlet var totalePrixLabel: UILabel!
    @IBOutlet var viewDuHeure: UIView!
    @IBOutlet var viewDuDate: UIView!
    @IBOutlet var heurefinLabel: UILabel!
    @IBOutlet var heuredebutLabel: UILabel!
    @IBOutlet var view4: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var duration: UILabel!
    @IBOutlet var prixanduniteLabel: UILabel!
    @IBOutlet var viewSeparator: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view1: UIView!
    @IBOutlet var datefinLabel: UILabel!
    @IBOutlet var datedebutLabel: UILabel!
    @IBOutlet var viewDateFin: UIView!
    @IBOutlet var viewDateDebut: UIView!
    var startdate  = Date()
    var enddate  = Date()
    var durree = String()
    var components = DateComponents()
    override func viewDidLoad() {
        super.viewDidLoad()
             styleView()
        prixanduniteLabel.text = "\(Share.sharedName.product?.price ?? 2) /  \( Share.sharedName.product?.enumUniteName ?? "jour")"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tap.delegate = self as? UIGestureRecognizerDelegate
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.tap2(_:)))
        tap2.delegate = self as? UIGestureRecognizerDelegate
        viewDateDebut.addGestureRecognizer(tap)
        viewDateFin.addGestureRecognizer(tap2)
//        guard let a = Double(durree) else {return}
//        print("durree a \(a)")
//         print("durree \(durree)")
      print("date du text \(duration.text)")
       print("date fin du text \(totalePrixLabel.text)")
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func dateduree() {
        
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: startdate as Date)
        let date2 = calendar.startOfDay(for: enddate as Date)
//        if self.enddate.compare(startdate).rawValue > self.startdate.compare(enddate).rawValue {
//            let favorite : String = "le date que vous choisir doit supperieur a la date de debut"
//
//            self.displayMessage(userMessage: favorite)
//        }
        components = calendar.dateComponents([.day], from: date1, to: date2)
        duration.text =  "\(components.day ?? 0 ) days"
        print("durree du text \(duration.text)")
        print("date du text \(datedebutLabel.text)")
        print("date fin du text \(datefinLabel.text)")
        print("component \(components.day)")
        guard let price = Share.sharedName.product?.price else {return}
        let priceDouble = Double(price)
        if Share.sharedName.product?.enumUniteName == "Jour" || Share.sharedName.product?.enumUniteName == "Pièces"   {
        let dureeDouble = Double(components.day!)
        let result = multiple(of: priceDouble, and: dureeDouble)
        print("result \(result)")
        totalePrixLabel.text = "\(result)"
        }
        if Share.sharedName.product?.enumUniteName == "Mois" {
            let priceParMois = priceDouble / 30
            let dureeDouble = Double(components.day!)
            let result = multiple(of: priceParMois, and: dureeDouble)
            let priceFormated = String(format: " %.2f", result)
            print("result \(priceFormated)")
            totalePrixLabel.text = priceFormated
        }
        if Share.sharedName.product?.enumUniteName == "Année" {
            let priceParAnnee = priceDouble / 365
            let dureeDouble = Double(components.day!)
            let result = multiple(of: priceParAnnee, and: dureeDouble)
            let priceFormated = String(format: " %.2f", result)
            print("result \(priceFormated)")
            totalePrixLabel.text = priceFormated
        }
    }

    func multiple(of a :Double, and b: Double ) -> Double {
        return a * b
    }

    func styleView () {

        viewDateDebut.layer.masksToBounds  = false
        viewDateDebut.backgroundColor = .white
        viewDateDebut.layer.cornerRadius = 14
        viewDateDebut.layer.shadowOffset = CGSize.zero
        viewDateDebut.layer.shadowRadius = 8
        viewDateDebut.layer.shadowOpacity = 0.2

        viewDateFin.layer.masksToBounds  = false
        viewDateFin.backgroundColor = .white
        viewDateFin.layer.cornerRadius = 14
        viewDateFin.layer.shadowOffset = CGSize.zero
        viewDateFin.layer.shadowRadius = 8
        viewDateFin.layer.shadowOpacity = 0.2
       
 
    }
  
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        let alertStyle: UIAlertController.Style = .alert
let alert = UIAlertController(title: "Date Picker", message: "Select Date", preferredStyle: alertStyle)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default ) {
            action in
            // self.dismiss(animated: true, completion: nil)
        }
        let date = Date()
        let calendar = Calendar.current
        
        let ymd = calendar.dateComponents([.year, .month, .day , .hour , .minute], from: date)
//    let cal   = calendar.component(.hour, from: date)
//        calendar.component(.month, from: date)
//        calendar.component([.year , .month , .day], from: date)
        
     
        print("eee\(ymd)")
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
       // let formattedDate = format.da(from: date)
        //print(formattedDate)
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: date , maximumDate: nil) { date in
            print(date)
         
            self.startdate = date
            self.datedebutLabel.text = "\(self.startdate)"


        }
        alert.addAction(okAction)
        self.present(alert , animated : true , completion : nil)
    }
    @objc func tap2(_ gestureRecognizer: UITapGestureRecognizer) {
        let alertStyle: UIAlertController.Style = .alert
        let alert = UIAlertController(title: "Date Picker", message: "Select Date", preferredStyle: alertStyle)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default ) {
            action in
            // self.dismiss(animated: true, completion: nil)
        }
      
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: startdate, maximumDate: nil) { date in
            print(date)
            self.enddate = date
            let formatter = DateFormatter()
            
            formatter.dateFormat = "dd-MMM-yyyy"
            // again convert your date to string
            let myStringafd = formatter.string(from: self.enddate)
            self.datefinLabel.text = "\(self.enddate)"
          
            self.dateduree()

        }
        
        alert.addAction(okAction)
        self.present(alert , animated : true , completion : nil)
      


    }


    func PostLocation () {
        guard let userId = AppManager.shared.iduser else {return}
        guard let productId = Share.sharedName.product?.id else {return}
        guard let productName = Share.sharedName.product?.name else {return}
        guard let duration = components.day else {return}
        guard let amount = totalePrixLabel.text else {return}
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
//        let myStringafd = formatter.string(from: startdate)
//        let myStringafd2 = formatter.string(from: enddate)
//
//        print("myStringafd \(myStringafd)")
//
//        print("myStringafd \(myStringafd2)")
        print("startdate \(startdate) ,startdate \(enddate)  , amount \(amount) , durationn \(duration) , userId \(userId) , productId  \(productId)")
        let parametre = ["userId": userId ,"productId": productId,"duration": duration,"startDate": "\(startdate)","endDate": "\(enddate)", "amount": amount , "isRequested": true,
                         "isConfirmed": false] as [String : Any]
        let urlString = "https://clocation.azurewebsites.net/api/Location"
        
        AF.request(urlString, method: .post, parameters: parametre,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            switch response.result {
            case .success:
                print(response)
                let favorite : String = "vous avez reservee le produit par \(productName)"
                self.displayMessage(userMessage: favorite)
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
//    func availibility() {
//
//        let urlString = "http://clocation.azurewebsites.net/api/Location/IsAvailable/"
//        guard let productId = Share.sharedName.product?.id  else {return}
//        let productURL = urlString! + "\(productId)"
//        print("productId : \(productId)")
//        let param = ["productId" :  Share.sharedName.product?.id ,"startDate" :  Share.sharedName.product?.,"endDate" :  Share.sharedName.product?.id]
//        AF.request(productURL , method : .get).responseJSON {
//            response in
//            do {
//                print("response \(response)")
//                guard let data = response.data else {return}
//                let itemDetails = try JSONDecoder().decode([Location].self, from: data)
//                print("item detaile \(itemDetails)")
//                for item  in itemDetails {
//                    self.locationList.append(item)
//                    guard let productId = item.productId else {return}
//                    self.searchImage(productId: productId)
//                    print(productId)
//
//                }
//                self.collectionView.reloadData()
//
//
//            }catch let errors {
//                print(errors)
//            }
//            self.activityIndicator.stopAnimating()
//            self.activityIndicator.isHidden = true
//        }
//
//        }
//    }
 
    @IBAction func louerButton(_ sender: Any) {
        PostLocation()
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
