//
//  DetailsViewModel.swift
//  JakDojadeRecruitmentApp
//
//  Created by Jacek Stąporek on 23/04/2024.
//

import Foundation
import MapKit
import CoreLocation

protocol DetailsViewModelDelegate: AnyObject {
    func didGetLocation()
}

class DetailsViewModel: NSObject {
    weak var delegate: DetailsViewModelDelegate?
    let locManager = CLLocationManager()
    var currentLocation: CLLocation?
    var stationData: StationsDataModel
    
    init(data: StationsDataModel) {
        self.stationData = data
    }
    
    func didLoad() {
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
    }
    
    func addPin(on mapView: MKMapView) {
        guard let lat = stationData.lat, let lon = stationData.lon else { return }
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.coordinate = centerCoordinate
        mapView.addAnnotation(annotation)
    }
    
    func showRouteOn(mapView: MKMapView) {
        guard let lat = stationData.lat, let lon = stationData.lon else { return }
        
        let request = MKDirections.Request()
        request.source = .forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: .init(latitude: lat, longitude: lon), addressDictionary: nil))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let response = response else { return }
            let quickest = response.routes.sorted(by: {$0.expectedTravelTime < $1.expectedTravelTime})
            if let route = quickest.first {
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 30.0), animated: true)
            }
        }
    }
    
    func getDistanceToDestination(completion: @escaping (String) -> ()) {
        guard currentLocation != nil, let lat = stationData.lat, let lon = stationData.lon else { return }
        
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
                completion("\(Int(distance.value)) \(distance.unit.symbol)")
            }
        }
    }
    
    func getBikesAvailable() -> Int {
        return stationData.bikesAvailable ?? 0
    }
}

extension DetailsViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
                currentLocation = manager.location
                delegate?.didGetLocation()
            }
        } else {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
                currentLocation = manager.location
                delegate?.didGetLocation()
            }
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
