//
//  MainViewModel.swift
//  JakDojadeRecruitmentApp
//
//  Created by Jacek Stąporek on 23/04/2024.
//

import Foundation
import MapKit
import CoreLocation

protocol MainViewModelDelegate: AnyObject {
    func didFetchData()
    func didGetLocation()
}

class MainViewModel: NSObject {
    weak var delegate: MainViewModelDelegate?
    var state: ViewState = .ready
    var stations: StationsModel?
    var locManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override init() {
        super.init()
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
    }
    
    func didLoad() {
        Api.getInfo { [weak self] info in
            let stationsInfo = info
            Api.getStatus { [weak self] status in
                for element in status.data.stations {
                    guard let index = stationsInfo.data.stations.firstIndex(where: { $0.stationId == element.stationId }) else { return }
                    stationsInfo.data.stations[index].isInstalled = element.isInstalled
                    stationsInfo.data.stations[index].isRenting = element.isRenting
                    stationsInfo.data.stations[index].isReturning = element.isReturning
                    stationsInfo.data.stations[index].lastReported = element.lastReported
                    stationsInfo.data.stations[index].vehiclesAvailable = element.vehiclesAvailable
                    stationsInfo.data.stations[index].bikesAvailable = element.bikesAvailable
                    stationsInfo.data.stations[index].dockAvailable = element.dockAvailable
                    stationsInfo.data.stations[index].vehiclesTypesAvailible = element.vehiclesTypesAvailible
                }
                self?.stations = stationsInfo
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFetchData()
                }
            }
        }
    }
    
    func getDistanceToDestination(lat: Double, lon: Double, completion: @escaping (String) -> ()) {
        guard currentLocation != nil else { return }
        
        let request = MKDirections.Request()
        request.source = .forCurrentLocation()
        request.destination = MKMapItem(placemark: .init(coordinate: .init(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let response = response else { return }
            
            let quickest = response.routes.sorted(by: {$0.expectedTravelTime < $1.expectedTravelTime})
            if let route = quickest.first {
                var distance = Measurement(value: route.distance, unit: UnitLength.meters)
                if distance.value > 1000 {
                    distance = distance.converted(to: .kilometers)
                }
                completion("\(Int(distance.value))\(distance.unit.symbol)")
            }
        }
    }
}

extension MainViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            guard manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways else { return }
            
            currentLocation = manager.location
            delegate?.didGetLocation()
        } else {
            guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways else { return }
            
            currentLocation = manager.location
            delegate?.didGetLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            delegate?.didGetLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
