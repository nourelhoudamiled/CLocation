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
    var firstName : String?
    var lastName : String?
    var aboutMe : String?
    let email : String?
    var phoneNumber : String?
    var skype : String?
    var facebookUrl : Bool?
    var twitterUrl : Int?
    var pinterestUrl: Int?
    var imageUri : String?
    var isAdmin : Bool?
    var isPartner : Bool?
    var partnerAddress : String?
    var partnerCity : String?
    var partnerDescription : String?
    var partnerWebSite : String?
    init(id : String , email : String ) {
        self.id = id
        self.email = email
        
    }
    
}
