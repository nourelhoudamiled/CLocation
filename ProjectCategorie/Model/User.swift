//
//  User.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 08/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation

struct User : Decodable {
    let id : String?
    let firstName : String?
    let lastName : String?
    let aboutMe : String?
    let email : String?
    let phoneNumber : String?
    let skype : String?
    let facebookUrl : Bool?
    let twitterUrl : Int?
    let pinterestUrl: Int?
    let imageUri : String?
    let isAdmin : Bool?
    let isPartner : Bool?
    let partnerAddress : String?
    let partnerCity : String?
    let partnerDescription : String?
    let partnerWebSite : String?
    
}
