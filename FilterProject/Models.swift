//
//  Club.swift
//  FizcultApp
//
//  Created by Artem Kolyadin on 13.08.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import Foundation

class AttributeFilter: Decodable {
    let id: String
    let name: String
    let description: String
    var isActive: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
        case isActive
        
    }
    
    init(id:String,name:String,isActive:Bool, description: String) {
        self.id = id
        self.name = name
        self.isActive = isActive
        self.description = description
    }
}

class CheckBoxFilter: Decodable {
    let id: String
    let name: String
    let description: String
    var isActive: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
        case isActive
    }
    
    init(id:String,name:String,isActive:Bool, description: String) {
        self.id = id
        self.name = name
        self.isActive = isActive
        self.description = description
    }
}

