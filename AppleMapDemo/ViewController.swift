//
//  ViewController.swift
//  AppleMapDemo
//
//  Created by Mac User5 on 3/14/18.
//  Copyright © 2018 Mac04. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate , MKMapViewDelegate{

    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var btnStandard: UIButton!
    @IBOutlet weak var btnSatellite: UIButton!
    @IBOutlet weak var btnHybrid: UIButton!

    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let sourceCoordinates = CLLocationCoordinate2DMake(19.0760, 72.8777)
        let destCoordinates = CLLocationCoordinate2DMake(51.4037, 0.2473)
        
        let span = MKCoordinateSpanMake(0.9 , 0.9)
        let region = MKCoordinateRegion(center: sourceCoordinates, span: span)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = sourceCoordinates
        annotation.title = "Mumbai"
        mapView.addAnnotation(annotation)
        
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = destCoordinates
        annotation1.title = "south darenth"
        mapView.addAnnotation(annotation1)

        let sourcePlacemark = MKPlacemark (coordinate: sourceCoordinates)
        let destPlacemark = MKPlacemark (coordinate: destCoordinates)
        
        let sourceItem = MKMapItem (placemark: sourcePlacemark)
        let destItem = MKMapItem (placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        
        let direction = MKDirections (request: directionRequest)
        direction.calculate { (response, error) in
            guard let response = response else{
                if let error = error{
                    print("Something went wrong")
                }
                return
            }
            let rout = response.routes[0]
            self.mapView.add(rout.polyline, level: .aboveRoads)
            
            let rekt = rout.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
        }
    }
    
    

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0

        return renderer
    }
    
    @IBAction func btnStandard(_ sender: UIButton) {
        mapView.mapType = .standard
    }
    @IBAction func btnSetelite(_ sender: UIButton) {
        mapView.mapType = .satellite
    }
    @IBAction func btnHybrid(_ sender: UIButton) {
        mapView.mapType = .hybrid
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

