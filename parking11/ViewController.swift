//
//  ViewController.swift
//  parking11
//
//  Created by John Mac on 12/7/16.
//  Copyright © 2016 John Wetters. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    lazy var locationManager : CLLocationManager = {
        
        let loc = CLLocationManager()
        
        //Set up location manager with defaults
        loc.desiredAccuracy = kCLLocationAccuracyBest
        loc.distanceFilter = kCLDistanceFilterNone
        loc.delegate = self
        
        //Optimisation of battery
        loc.pausesLocationUpdatesAutomatically = true
        loc.activityType = CLActivityType.fitness
        loc.allowsBackgroundLocationUpdates = false
        
        return loc
    }()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.requestAlwaysAuthorization()
        //Map
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.hybrid
        mapView.userTrackingMode = .follow
        mapView.showsTraffic = true
        mapView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedAlways {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = MKUserTrackingMode.follow
        } else {
            print("Permission Refused")
        }
    }


}

