//
//  StationsDataModel.swift
//  JakDojadeRecruitmentApp
//
//  Created by Jacek Stąporek on 23/04/2024.
//

import Foundation

class StationsDataModel: Decodable {
    let stationId: String
    let name: String?
    let address: String?
    let crossStreet: String?
    let lat: Double?
    let lon: Double?
    let isVirtualStation: Bool?
    let capacity: Int?
    let stationArea: StationAreaModel?
    
    let isInstalled: Bool?
    let isRenting: Bool?
    let isReturning: Bool?
    let lastReported: Int?
    let vehiclesAvailable: Int?
    let bikesAvailable: Int?
    let dockAvailable: Int?
    let vehiclesTypesAvailible: [VehiclesTypesAvailableModel]?
    
    enum CodingKeys: String, CodingKey {
        case stationId = "station_id"
        case name
        case address
        case crossStreet = "cross_street"
        case lat
        case lon
        case isVirtualStation = "is_virtual_station"
        case capacity
        case stationArea = "station_area"
        case isInstalled = "is_installed"
        case isRenting = "is_renting"
        case isReturning = "is_returning"
        case lastReported = "last_reported"
        case vehiclesAvailable = "num_vehicles_available"
        case bikesAvailable = "num_bikes_available"
        case dockAvailable = "num_docks_available"
        case vehiclesTypesAvailible = "vehicle_types_available"
    }
}
    
class StationAreaModel: Decodable {
    let type: String
    let coordinates: [CoordinatesModel]
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)
        let coordinates = try values.decode([[[[Double]]]].self, forKey: .coordinates)
        let flattened = coordinates.flatMap{$0}.flatMap{$0}
        var myCoordinates: [CoordinatesModel] = []
        
        for element in flattened {
            if element.count == 2,
               let first = element.first,
               let last = element.last {
                myCoordinates.append(.init(lat: first, long: last))
            }
        }
        self.coordinates = myCoordinates
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }
}

class CoordinatesModel: Decodable {
    let lat: Double
    let long: Double
    
    init(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }
}

class RentalUrisModel: Decodable {
    let android: String
    let ios: String
}

class VehiclesTypesAvailableModel: Decodable {
    let vehicleTypeId: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case vehicleTypeId = "vehicle_type_id"
        case count
    }
}
