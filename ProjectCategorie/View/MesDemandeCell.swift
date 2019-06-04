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
    
    @IBOutlet var totaleLabel: UILabel!
    @IBOutlet var durrationLabel: UILabel!
    @IBOutlet var periodLabel: UILabel!
    @IBOutlet var viewOfLabel: UIView!
   
    @IBAction func cancelButton(_ sender: Any) {
        delegate?.deleteData(indx: index!.row)

    }
    @IBAction func requestButton(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }

}
