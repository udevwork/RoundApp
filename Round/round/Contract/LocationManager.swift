//
//  LocationManager.swift
//  round
//
//  Created by Denis Kotelnikov on 04.05.2020.
//  Copyright © 2020 Denis Kotelnikov. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let loc : CLLocationManager = CLLocationManager()
    public func update() {
        if authorizatization() {
            loc.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
  //          loc.requestLocation()
        }
    }
    
    @discardableResult
    public func authorizatization() -> Bool{
        switch CLLocationManager.authorizationStatus(){
        case .denied,.notDetermined,.restricted:
            return false
        default:
            return true
        }
    }

    public func getLocation(completion : @escaping (Location)->()) {
        let geoCoder = CLGeocoder()
        guard let location = loc.location else {
            return
        }
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var resultLocation : Location = Location()
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            resultLocation.latitude = location.coordinate.latitude.description
            resultLocation.longitude = location.coordinate.longitude.description
            
            if let street = placeMark.thoroughfare {
                resultLocation.street = street
            }
            if let city = placeMark.subAdministrativeArea {
                resultLocation.city = city
            }
            if let country = placeMark.country {
                resultLocation.country = country
            }
            completion(resultLocation)
        })
    }

}
