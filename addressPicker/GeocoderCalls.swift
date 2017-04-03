//
//  GeocoderCalls.swift
//  addressPicker
//
//  Created by Fabio Santoro on 02/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import Foundation
import CoreLocation

protocol GeocoderClassDelegate: class  {
    func onReversedGeocoderLocationFinished(_ placemark: [CLPlacemark?], isWithError error: Bool)
    func onGeocoderLocationFromStringFinished(_ placemark: [CLPlacemark?], isWithError error: Bool)
}

class GeocoderCalls {
    
    weak var delegate: GeocoderClassDelegate?
    private var geocoderObj = CLGeocoder()
    
    /**
     * Get the location details giving coordinates
     */
    func getReverseGeocodeLocation(forLocation location: CLLocation) {
        geocoderObj.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if (error != nil) {
                self.delegate?.onReversedGeocoderLocationFinished([nil], isWithError: true)
            } else {
                self.delegate?.onReversedGeocoderLocationFinished(placemarks!, isWithError: false)
            }
        })
    }
    
    /**
     * Get the location details giving string location
     */
    func getGeocoderLocationFromString(forLocation location: String) {
        geocoderObj.geocodeAddressString(location, completionHandler: { (placemarks, error) -> Void in
            if (error != nil) {
                self.delegate?.onGeocoderLocationFromStringFinished([nil], isWithError: true)
            } else {
                self.delegate?.onGeocoderLocationFromStringFinished(placemarks!, isWithError: false)
            }
        })
    }
    
}
