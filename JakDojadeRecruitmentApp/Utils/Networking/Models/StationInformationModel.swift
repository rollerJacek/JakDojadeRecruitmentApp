//
//  StationInformationModel.swift
//  JakDojadeRecruitmentApp
//
//  Created by Jacek Stąporek on 23/04/2024.
//

import Foundation

class StationInformationModel: Decodable {
    var lastUpdated: Int
    var ttl: Int
    var version: String
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
