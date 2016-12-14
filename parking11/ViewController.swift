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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
     let picker = UIImagePickerController()
    
    var count = 0
    var dropPin=false
     let annotation = MKPointAnnotation()

    
    @IBOutlet var imageView: UIImageView!
    
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
        print("set location manager")
        
        return loc
    }()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.requestAlwaysAuthorization()
        //Map
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.hybrid
        //mapView.userTrackingMode = .follow
        mapView.showsTraffic = true
        mapView.delegate = self
        self.locationManager.startUpdatingLocation()
        print("start location manager")
        
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        //picker.popoverPresentationController?.barButtonItem = sender

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
        
        //add annotation
        if dropPin==true{
            annotation.title = "My Parking Location"
            annotation.coordinate = center
            mapView.addAnnotation(annotation)
            dropPin=false
            
        }
       

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error: " + error.localizedDescription)
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedAlways {
            mapView.showsUserLocation = true
            //mapView.userTrackingMode = MKUserTrackingMode.follow
        } else {
            print("Permission Refused")
        }
    }
    
    
    
    @IBAction func Pin(_ sender: Any) {
        dropPin=true
         print("drop pin")
        
    }

    @IBAction func Stop(_ sender: Any) {
        dropPin=false
        mapView.removeAnnotations([annotation])
        print("remove pin")
    }
    
    //MARK: - Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
        //        {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageView.contentMode = .scaleAspectFit //3
        imageView.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


}

