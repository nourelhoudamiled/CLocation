//
//  ProductClass.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 01/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import  UIKit

struct ProductClass : Decodable {
    let id : Int?
    let name : String?
    let description : String?
    let price : Int?
    let address : String?
    let isAvailable : Bool?
    let enumCityId : Int?
    let enumSubCategoryId: Int?
    let enumCityName : String?
    let enumSubCategoryName : String?
    let enumUniteName : String?
    let userId : String?
    let userName : String?
    let enumRegionId : Int?
    let enumCategoryId : Int?
     //  var hasFavorited: Bool?
    let  phoneNumber : String?
    let aboutMe : String?
    let firstName : String?
    
    
}
