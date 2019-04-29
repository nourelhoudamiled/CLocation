//
//  Comment.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 26/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
struct Comment : Decodable{
    let id : Int?
   let userId: String?
    let userName: String?
    let productId: Int?
    let productName: String?
    let commentaire: String?
}
