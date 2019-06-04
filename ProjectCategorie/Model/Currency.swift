//
//  Currency.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 03/06/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation

struct Currency : Decodable {
    let id : String
    let name: String
     let symbol : String
     let ordinal: Int
     let isAvailable: Bool
     let note: String
    
}
