//
//  ViewController.swift
//  addressPicker
//
//  Created by Fabio Santoro on 02/04/2017.
//  Copyright © 2017 santoro. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onOpenMapControllerClicked(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyBoard.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
        
        mapViewController.delegate = self
        
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
}

extension ViewController : MapViewControllerDelegate {
    func onAddressDetailsRetrieved(withAddress address: String, latitude lat: CLLocationDegrees, andLongitude lon: CLLocationDegrees) {
        
        addressTextView.text = address
        latitudeLabel.text = String(lat)
        longitudeLabel.text = String(lon)
        
    }
}

