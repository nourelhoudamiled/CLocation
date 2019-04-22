//
//  Rating.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 08/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation

struct Rating  {
    var id : Int?
    let note : Double?
   var productId : Int?
    var productName : String?
    var userId : String?
   var userName : String?
    init(note : Double) {
        self.note = note
        
    }
}
