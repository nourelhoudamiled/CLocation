//
//  Location.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 10/05/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
struct Location : Decodable {
    
    let id : Int?
    let duration: Int?
    let startDate : String?
    let endDate : String?
    let amount : Decimal?
    let isRequested : Bool?
    var isConfirmed : Bool?
    let modifiedDate : String?
    let userId : String?
    let userName : String?
    let productId : Int?
    let productName : String?
}

