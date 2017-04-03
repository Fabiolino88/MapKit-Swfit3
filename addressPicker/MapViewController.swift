//
//  MapViewController.swift
//  addressPicker
//
//  Created by Fabio Santoro on 02/04/2017.
//  Copyright © 2017 Fabio Santoro. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol MapViewControllerDelegate : class {
    func onAddressDetailsRetrieved(withAddress address: String, latitude lat:CLLocationDegrees, andLongitude lon: CLLocationDegrees)
}

class MapViewController: UIViewController {
    
    //Properties declaration
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    let mapViewModel = MapViewModelController()
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    //MapViewControllerDelegate
    weak var delegate : MapViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Delegate the viewmodel
        mapViewModel.delegate = self
        
        //Check location permission
        askForWhenInUseLocationPermission()
        
        //Add map single tap gesture recognizer
        let mapSingleTap = UITapGestureRecognizer(target: self, action: #selector(onMapViewSingleTapEvent(_:)))
        mapView.addGestureRecognizer(mapSingleTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * Check whenInUse location permission
     */
    private func askForWhenInUseLocationPermission() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        //Check if the authorization has been already asked
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    /*
     * On put annotation on current user location
     */
    @IBAction func onCenterUserPositionClicked(_ sender: UIBarButtonItem) {
        saveBarButton.isEnabled = false
        
        if (mapView.userLocation.coordinate.latitude != 0.0 && mapView.userLocation.coordinate.longitude != 0.0) {
            mapViewModel.getInfoFromLocation(forLatitude: mapView.userLocation.coordinate.latitude, andLongitude: mapView.userLocation.coordinate.longitude)
        }
    }
    
    /*
     * Handle the single tap event on mapView
     */
    func onMapViewSingleTapEvent(_ sender: UIGestureRecognizer) {
        saveBarButton.isEnabled = false
        
        let tappedPoint = sender.location(in: mapView)
        let pointCoordinate : CLLocationCoordinate2D = mapView.convert(tappedPoint, toCoordinateFrom: mapView)
        
        mapViewModel.getInfoFromLocation(forLatitude: pointCoordinate.latitude, andLongitude: pointCoordinate.longitude)
    }
    
    
    /*
     * On save button tap
     */
    @IBAction func onSaveButtonClicked(_ sender: UIBarButtonItem) {
        
        if mapView.annotations.count > 0 && mapView.selectedAnnotations.count > 0 {
            let currentAnnotation = mapView.selectedAnnotations.first!
            let annotationTitle = currentAnnotation.title != nil ? String(describing: (currentAnnotation.title!)!) : ""
            let annotationSubtitle = currentAnnotation.subtitle != nil ? String(describing: (currentAnnotation.subtitle!)!) : ""
            
            //Check if title is empty
            if annotationTitle.characters.count == 0 {
                showErrorAlert()
                return
            }
            
            self.delegate?.onAddressDetailsRetrieved(withAddress: annotationTitle + " " + annotationSubtitle, latitude: currentAnnotation.coordinate.latitude, andLongitude: currentAnnotation.coordinate.longitude)
            
            self.navigationController?.popToRootViewController(animated: true)
            
        } else {
            showErrorAlert()
        }
        
    }
    
    /*
     * Function to show and alertController in case of errors
     */
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please select a valid location!", preferredStyle: UIAlertControllerStyle.alert)
        let alertOkAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(alertOkAction)
        alertController.show(self, sender: nil)
    }
    
    
}

/*
 * ViewModel delegation and func to add an Annotation on map function
 */
extension MapViewController : MapViewModelControllerDelegate {
    func onGeocoderCallsFinished(_ pointInfo: NSDictionary) {
        //here add the resposne
        addMapAnnotation(withInfo: pointInfo)
    }
    
    func addMapAnnotation(withInfo info: NSDictionary) {
        let newPointAnnotation = MKPointAnnotation()
        
        newPointAnnotation.coordinate = CLLocationCoordinate2D(latitude: info.object(forKey: "Latitude") as! CLLocationDegrees, longitude: info.object(forKey: "Longitude") as! CLLocationDegrees)
        
        //Create all the annotation text title and subtitle
        var streetArray : [String] = info.object(forKey: "AddressLines") as! [String]
        newPointAnnotation.title = streetArray[0]
        streetArray.remove(at: 0)
        newPointAnnotation.subtitle = streetArray.joined(separator: ", ")
        
        //Remove all the annotation before to add the new one
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotation(newPointAnnotation)
        mapView.showAnnotations([newPointAnnotation], animated: false)
        
        //To show automatically the label of the new point
        //need to add the selectAnnotation method asyncronously in the main queue
        DispatchQueue.main.async {
            self.mapView.selectAnnotation(newPointAnnotation, animated: true)
            self.saveBarButton.isEnabled = true
        }
        
    }

}

/*
 * LocationManager Delegation
 * for now are not used but i'm finking at some future implementation
 */
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NSLog("On location updated")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error on location manager initialize")
    }
}
