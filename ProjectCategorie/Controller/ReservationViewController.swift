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

    @IBOutlet var reserverButton: UIButton!
    @IBOutlet var dispoLabel: UILabel!
    @IBOutlet var viewTotale: UIView!
    @IBOutlet var viewDuration: UIView!
    @IBOutlet var viewOfDays: UIView!
    @IBOutlet var viewOfAmount: UIView!
    @IBOutlet var tableView: UIView!
    @IBOutlet var BigView: UIView!
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
    var notevalue = Int()
    var startdate  = Date()
    var enddate  = Date()
    var durree = String()
    var product : ProductClass?

    var components = DateComponents()
    override func viewDidLoad() {
        super.viewDidLoad()
             styleView()
        prixanduniteLabel.text = "\(Share.sharedName.product?.price ?? 2) DT /  \( Share.sharedName.product?.enumUniteName ?? "jour")"
        guard let price = Share.sharedName.product?.price else {return}
        let priceDouble = Double(price)
        if Share.sharedName.product?.enumUniteName == "Mois" {
            let priceParMois = priceDouble / 30
            let priceFormated = String(format: " %.2f", priceParMois)
          totalePrixLabel.text = "\(priceFormated)"
        }
        if Share.sharedName.product?.enumUniteName == "Année" {
            let priceParAnnee = priceDouble / 365
            let priceFormated = String(format: " %.2f", priceParAnnee)

            totalePrixLabel.text = "\(priceFormated)"
        }
        if Share.sharedName.product?.enumUniteName == "Jour"   {
           let priceFormated = String(format: " %.2f", priceDouble)
            totalePrixLabel.text = "\(priceFormated)"
        }
        datedebutLabel.text = Date().toString()
        datefinLabel.text = Date().toString()

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tap.delegate = self as? UIGestureRecognizerDelegate
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.tap2(_:)))
        tap2.delegate = self as? UIGestureRecognizerDelegate
        viewDateDebut.addGestureRecognizer(tap)
        viewDateFin.addGestureRecognizer(tap2)
    
        BigView.layer.borderWidth = 1.0
        BigView.layer.borderColor = UIColor.gray.cgColor
        viewTotale.layer.borderWidth = 1.0
        viewTotale.layer.borderColor = UIColor.gray.cgColor
        viewDuration.layer.borderWidth = 1.0
        viewDuration.layer.borderColor = UIColor.gray.cgColor
        viewOfAmount.layer.borderWidth = 1.0
        viewOfAmount.layer.borderColor = UIColor.gray.cgColor
        viewOfDays.layer.borderWidth = 1.0
        viewOfDays.layer.borderColor = UIColor.gray.cgColor
     availibility(debut: Date().toString(), fin: Date().toString())
        print("startdate \(startdate) ,startdate \(enddate)  , amount \(totalePrixLabel.text) , durationn \(components.day) , userId \("5db395d9-3b02-4c27-bb19-0f4c6ce8b851") , productId  \( Share.sharedName.product?.id)")
        
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
    }
  
    func dateduree() {
        
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: startdate as Date)
        let date2 = calendar.startOfDay(for: enddate as Date)
        components = calendar.dateComponents([.day], from: date1, to: date2)
        let plusF = plus(of: components.day ?? 0, and: 1)
     print("plusun \(plusF)")
        duration.text =  "\(plusF) days"
 
        guard let price = Share.sharedName.product?.price else {return}
        let priceDouble = Double(price)
        if Share.sharedName.product?.enumUniteName == "Jour" || Share.sharedName.product?.enumUniteName == "Pièces"   {
        let dureeDouble = Double(components.day!  ) + 1
        let result = multiple(of: priceDouble, and: dureeDouble)
        print("result \(result)")
        totalePrixLabel.text = "\(result)"
        }
        if Share.sharedName.product?.enumUniteName == "Mois" {
            let priceParMois = priceDouble / 30
            let dureeDouble = Double(components.day!)
            let plusun = dureeDouble + 1
            print("plusun \(plusun)")
            let result = multiple(of: priceParMois, and: plusun)
            let priceFormated = String(format: " %.2f", result)
            print("result \(priceFormated)")
            totalePrixLabel.text = priceFormated
        }
        if Share.sharedName.product?.enumUniteName == "Année" {
            let priceParAnnee = priceDouble / 365
            let dureeDouble = Double(components.day!)
            let plusun = dureeDouble + 1
            print(plusun)
            let result = multiple(of: priceParAnnee, and: dureeDouble)
            let priceFormated = String(format: " %.2f", result)
            print("result \(priceFormated)")
            totalePrixLabel.text = priceFormated
        }
    }
    func plus(of a :Int, and b: Int ) -> Int {
        return a + b
    }
    func multiple(of a :Double, and b: Double ) -> Double {
        return a * b
    }

    func styleView () {

        viewDateDebut.layer.masksToBounds  = false
        viewDateDebut.backgroundColor = .white
        viewDateDebut.layer.shadowOffset = CGSize.zero
        viewDateDebut.layer.shadowRadius = 8
        viewDateDebut.layer.shadowOpacity = 0.2

        viewDateFin.layer.masksToBounds  = false
        viewDateFin.backgroundColor = .white
        viewDateFin.layer.shadowOffset = CGSize.zero
        viewDateFin.layer.shadowRadius = 8
        viewDateFin.layer.shadowOpacity = 0.2
       
 
    }
  
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        let alertStyle: UIAlertController.Style = .alert
let alert = UIAlertController(title: "Date Picker", message: "Select Date", preferredStyle: alertStyle)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default ) {
            action in
        }
        let date = Date()
        let calendar = Calendar.current
        
        let ymd = calendar.dateComponents([.year, .month, .day , .hour , .minute], from: date)
        print("eee\(ymd)")
     
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: Date() , maximumDate: nil) { date in
            print(date)
         
            self.startdate = date
            if self.startdate < self.enddate {
                self.datedebutLabel.text = self.startdate.toString()
                self.datefinLabel.text = self.enddate.toString()
                self.availibility(debut: self.startdate.toString()
                    , fin: self.enddate.toString())
                self.dateduree()

            }
            else {
                self.datedebutLabel.text = self.startdate.toString()
                self.datefinLabel.text = self.startdate.toString()
                self.availibility(debut: self.startdate.toString()
                    , fin: self.startdate.toString())
            }
        
           
       



        }
        alert.addAction(okAction)
        self.present(alert , animated : true , completion : nil)
    }
    @objc func tap2(_ gestureRecognizer: UITapGestureRecognizer) {
        let alertStyle: UIAlertController.Style = .alert
        let alert = UIAlertController(title: "Date Picker", message: "Select Date", preferredStyle: alertStyle)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default ) {
            action in
        }
      
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: startdate, maximumDate: nil) { date in
            print(date)
            self.enddate = date
            

            self.datefinLabel.text = self.enddate.toString()
          
            self.dateduree()
            self.availibility(debut: self.startdate.toString()
                , fin: self.enddate.toString())
            print("rr\(self.notevalue)")


        }
        
        alert.addAction(okAction)
        self.present(alert , animated : true , completion : nil)
      


    }


    func PostLocation () {
//        guard let userId = AppManager.shared.iduser else {return}
        let userId = "5db395d9-3b02-4c27-bb19-0f4c6ce8b851"
        guard let productId = Share.sharedName.product?.id else {return}
        guard let productName = Share.sharedName.product?.name else {return}
        guard let duration = components.day else {return}
        guard let amount = totalePrixLabel.text else {return}
      

        print("startdate \(startdate) ,startdate \(enddate)  , amount \(amount) , durationn \(duration) , userId \(userId) , productId  \(productId)")
        let parametre = ["userId": userId ,"productId": productId,"duration": duration,"startDate": "\(startdate)","endDate": "\(enddate)", "amount": amount , "isRequested": true,
                         "isConfirmed": false] as [String : Any]
        let urlString = "https://clocation.azurewebsites.net/api/Location"
        
        AF.request(urlString, method: .post, parameters: parametre,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            let favorite : String = "you reserved the product by name \(productName)"
            let alert = UIAlertController(title: "Alert", message: favorite, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (nil) in
                switch response.result {
                case .success:
                print(response)
                
                //    self.displayMessageOui(userMessage: favorite)
                
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
    func availibility(  debut : String , fin : String){

        let urlString = "http://clocation.azurewebsites.net/api/Location/IsAvailable/"
        guard let productId = Share.sharedName.product?.id  else {return}

//   let productURL = urlString + "\(productId)/" + "\(self.startdate.toString())/" + "\(self.enddate.toString())"
        let productURL = urlString + "\(productId)/" + debut + "/" + fin
   print(productURL)
        AF.request(productURL , method : .get).responseJSON {
            response in
           //guard let data = response.data else {return}
                print("response \(response.result)")
            self.notevalue = response.value as! Int
               print("ee\(response.value)")
          
            if self.notevalue == 0 {
                self.dispoLabel.text = "Cet article n'est pas disponible à ces dates"
                self.reserverButton.isEnabled = false

                self.dispoLabel.textColor = .mainRed
                print("rr\(self.notevalue)")
            }
            else {
                self.dispoLabel.text = "Cet article est disponible à ces dates"
                self.dispoLabel.textColor = .mainVert
                self.reserverButton.isEnabled = true

                print("rr\(self.notevalue)")
            }
           


        
        }

        
    }

    @IBAction func louerButton(_ sender: Any) {
       
       
        PostLocation()
  
    }
    
    
}
