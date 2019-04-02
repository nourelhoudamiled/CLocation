//
//  SousCategClass.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 25/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit

struct SousCategClass : Decodable {
    let name : String?
    let enumCategoryId : Int?
    let enumCategoryName : String?
    let id : Int?
    let sousCate  : [CategorieClass]?
//    init(name : String , enumCategoryId : Int , enumCategoryName : String , sousCate: [CategorieClass]) {
//        self.name  = name
//        self.enumCategoryId = enumCategoryId
//        self.enumCategoryName = enumCategoryName
//        self.sousCate = sousCate
////        for sc in sousCate {
////            self.sousCate?.append(CategorieClass(name: sc.name))
////
////
////        }
//    }
}
