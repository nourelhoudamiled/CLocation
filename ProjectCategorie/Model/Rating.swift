//
//  Rating.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 08/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation

struct Rating : Decodable {
    let id : Int?
    let note : Double?
   let productId : Int?
    let productName : String?
    let userId : String?
   let userName : String?
   
}
