//
//  ReservationViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 10/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController {

    @IBOutlet var datefinLabel: UILabel!
    @IBOutlet var datedebutLabel: UILabel!
    @IBOutlet var viewDateFin: UIView!
    @IBOutlet var viewDateDebut: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        styleView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tap.delegate = self as? UIGestureRecognizerDelegate
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.tap2(_:)))
        tap2.delegate = self as? UIGestureRecognizerDelegate
        viewDateDebut.addGestureRecognizer(tap)
        viewDateFin.addGestureRecognizer(tap2)


    }
    func styleView () {
//        cell.imageCat.layer.cornerRadius = 20.0
//        cell.viewCell.layer.cornerRadius = 10
//
//        cell.viewCell.layer.shadowColor = UIColor.black.cgColor
//        cell.viewCell.layer.shadowOpacity = 1
//        cell.viewCell.layer.shadowOffset = CGSize.zero
//        cell.viewCell.layer.shadowRadius = 10
        viewDateDebut.layer.masksToBounds  = false
        viewDateDebut.backgroundColor = .white
        viewDateDebut.layer.cornerRadius = 14
        viewDateDebut.layer.shadowOffset = CGSize.zero
        viewDateDebut.layer.shadowRadius = 8
        viewDateDebut.layer.shadowOpacity = 0.2
//        viewDateDebut.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 14, height: 14)).cgPath
        viewDateFin.layer.masksToBounds  = false
        viewDateFin.backgroundColor = .white
        viewDateFin.layer.cornerRadius = 14
        viewDateFin.layer.shadowOffset = CGSize.zero
        viewDateFin.layer.shadowRadius = 8
        viewDateFin.layer.shadowOpacity = 0.2
//        viewDateFin.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 14, height: 14)).cgPath
        
    
    }
  
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        let alertStyle: UIAlertController.Style = .alert
let alert = UIAlertController(title: "Date Picker", message: "Select Date", preferredStyle: alertStyle)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default ) {
            action in
            // self.dismiss(animated: true, completion: nil)
        }
        alert.addDatePicker(mode: .dateAndTime, date: Date(), minimumDate: nil, maximumDate: nil) { date in
            print(date)
         
            self.datedebutLabel.text = "\(date)"

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
        alert.addDatePicker(mode: .dateAndTime, date: Date(), minimumDate: nil, maximumDate: nil) { date in
            print(date)
            self.datefinLabel.text = "\(date)"
            
        }
        alert.addAction(okAction)
        self.present(alert , animated : true , completion : nil)
    }

 
    @IBAction func louerButton(_ sender: Any) {
    }
    
}
