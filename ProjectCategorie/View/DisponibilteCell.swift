//
//  DisponibilteCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 17/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import  Koyomi
import FSCalendar
class DisponibilteCell: UITableViewCell {
    let invalidPeriodLength = 90
    var tt : louerViewController?
    var index : IndexPath?
    @IBOutlet  weak var koyomi: Koyomi! {
        didSet {
            koyomi.circularViewDiameter = 0.2
            koyomi.calendarDelegate = self
            koyomi.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            koyomi.weeks = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
            koyomi.style = .standard
            koyomi.dayPosition = .center
            koyomi.selectionMode = .sequence(style: .semicircleEdge)
            koyomi.selectedStyleColor = UIColor(red: 203/255, green: 119/255, blue: 223/255, alpha: 1)
            koyomi
                .setDayFont(size: 14)
                .setWeekFont(size: 10)
        }
    }
    @IBOutlet var fsCalendar: FSCalendar!
    @IBOutlet var currentDateLabel: UILabel!
    @IBOutlet  weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.setTitle("Previous", forSegmentAt: 0)
            segmentedControl.setTitle("Current", forSegmentAt: 1)
            segmentedControl.setTitle("Next", forSegmentAt: 2)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        koyomi.reloadData()

        currentDateLabel.text = koyomi.currentDateString()

        let today = DateFormatter()
        today.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = today.date(from: "2019-06-22T00:00:00")
        var components = DateComponents()
        components.day = 7
        let weekLaterDay = Calendar.current.date(byAdding: components, to: date!)
        koyomi.select(date: date!, to: weekLaterDay)
        // Initialization code
    }
    @IBAction func tappedControl(_ sender: UISegmentedControl) {
//        tt?.tapped(cell : self , sender : sender)
//        let month: MonthType = {
//            switch sender.selectedSegmentIndex {
//            case 0:  return .previous
//            case 1:  return .current
//            default: return .next
//            }
//        }()
//     koyomi.display(in: month)
     }
    // Utility
    func configureStyle(_ style: KoyomiStyle) {
        koyomi.style = style
        koyomi.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       currentDateLabel.text = koyomi.currentDateString()
        koyomi.reloadData()


        // Configure the view for the selected state
    }
   func date(_ date: Date, later: Int) -> Date {
        var components = DateComponents()
    components.day = later
        return (Calendar.current as NSCalendar).date(byAdding: components, to: date, options: NSCalendar.Options(rawValue: 0)) ?? date
    }
    
}
// MARK: - KoyomiDelegate -

extension DisponibilteCell: KoyomiDelegate {
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        print("You Selected: \(date)")
    }

    func koyomi(_ koyomi: Koyomi, currentDateString dateString: String) {
    koyomi.currentDateFormat = "yyyy/MM/dd"

        currentDateLabel.text = dateString
    }


    @objc(koyomi:shouldSelectDates:to:withPeriodLength:)
    func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
        print("Start date \(date)")
        print("End date : \(toDate)")
        if length > invalidPeriodLength {

            print("More than \(invalidPeriodLength) days are invalid period.")
            return false
        }
        return true
    }
}

