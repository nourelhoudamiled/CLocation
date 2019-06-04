//
//  Share.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 12/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
final class Share {
    static let sharedName = Share()
      var subcategorieName : String!
    var categorieName : String!
       var categorieId : Int!
        var SubcategorieId : Int!
    var CityName : String!
      var CityId : Int!
    var RegionName : String!
    var RegionId : Int!
    var nameAdresse : String!
//    var idUser : String!
       var lan : String!
       var latitude : Decimal!
    var longitude : Decimal!
      var sousCategorie : SousCategClass?
    var product : ProductClass?
    var uniteName : String!
    var uniteId : Int!
    var currencySymbol : String!
    var currencyId : String!
    var etatName : String!
    var etatId : Int!
    
}
