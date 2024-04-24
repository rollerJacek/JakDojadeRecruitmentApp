//
//  StationsModel.swift
//  JakDojadeRecruitmentApp
//
//  Created by Jacek Stąporek on 23/04/2024.
//

import Foundation

class StationsModel: Decodable {
    let lastUpdated: Int
    let ttl: Int
    let version: String
    let data: DataModel
    
    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case ttl
        case version
        case data
    }
    
    class DataModel: Decodable {
        let stations: [StationsDataModel]
    }
}
