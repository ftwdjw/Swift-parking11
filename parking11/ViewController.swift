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
    
    var count = 0
    
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
        print("set locaton manager")
        
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
        self.locationManager.startUpdatingLocation()
        print("start location manager")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Location Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        count += 1
        
        print("update last location \(count)")
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        //self.locationManager.stopUpdatingLocation()
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error:NSError)
    {
        print("Error: " + error.localizedDescription)
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

