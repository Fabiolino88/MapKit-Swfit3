//
//  MapViewModelController.swift
//  addressPicker
//
//  Created by Fabio Santoro on 02/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import Foundation
import CoreLocation

protocol MapViewModelControllerDelegate : class {
    func onGeocoderCallsFinished(_ pointInfo: NSDictionary)
}

class MapViewModelController {
    
    weak var delegate : MapViewModelControllerDelegate?
    
    func getInfoFromLocation(forLatitude latitude: CLLocationDegrees, andLongitude longitude: CLLocationDegrees) {
        let geocoderCalls = GeocoderCalls()
        geocoderCalls.delegate = self
        geocoderCalls.getReverseGeocodeLocation(forLocation: CLLocation(latitude: latitude, longitude: longitude))
    }
    
}

/*
 * GeocoderCall delegation
 */
extension MapViewModelController : GeocoderClassDelegate {
    
    func onReversedGeocoderLocationFinished(_ placemark: [CLPlacemark?], isWithError error: Bool) {
        self.delegate?.onGeocoderCallsFinished(getResponseDictionary(placemark))
    }
    
    func onGeocoderLocationFromStringFinished(_ placemark: [CLPlacemark?], isWithError error: Bool) {
        self.delegate?.onGeocoderCallsFinished(getResponseDictionary(placemark))
    }
    
    //prepare the response dictionary getting the info (address, latitude and longitude) from the placemark
    private func getResponseDictionary(_ placemark: [CLPlacemark?]) -> NSDictionary {
        let responseDictionary : NSDictionary = ["AddressLines" : placemark[0]!.addressDictionary!["FormattedAddressLines"] as! [String],
                                                 "Latitude" : placemark[0]!.location!.coordinate.latitude,
                                                 "Longitude" : placemark[0]!.location!.coordinate.longitude]
        return responseDictionary
    }
    
}
