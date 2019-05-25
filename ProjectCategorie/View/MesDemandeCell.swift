//
//  MesDemandeCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 16/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
protocol MesDemandeReservationProtocol {
    
    func deleteData (indx : Int )
}
class MesDemandeCell: UICollectionViewCell {
    var delegate : MesDemandeReservationProtocol?
   
    var index : IndexPath?
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var requestButton: UIButton!
    @IBOutlet var imageProduit: UIImageView!
    @IBOutlet var nameProduit: UILabel!
    
    @IBOutlet var periodLabel: UILabel!
    @IBOutlet var viewOfLabel: UIView!
   
    @IBAction func cancelButton(_ sender: Any) {
        delegate?.deleteData(indx: index!.row)

    }
    @IBAction func requestButton(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        requestButton.layer.cornerRadius = 10
        requestButton.layer.borderWidth = 1.0
        requestButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UIColor.black.cgColor
        
    }

}
