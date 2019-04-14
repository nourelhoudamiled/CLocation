//
//  PopUpAddresseViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 13/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import GoogleMaps
protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}
class PopUpAddresseViewController: UIViewController  {

    @IBOutlet var mapView: MKMapView!
   
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    
    let locationManager = CLLocationManager()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self as? HandleMapSearch
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @IBAction func saveLocationButton(_ sender: Any) {
    
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AjouterProduitViewController") as! AjouterProduitViewController
        self.present(newViewController, animated: true, completion: nil)
    }
}
    extension PopUpAddresseViewController : CLLocationManagerDelegate {
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                locationManager.requestLocation()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else { return }
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error:: \(error)")
        }
        
    }
    
extension PopUpAddresseViewController: HandleMapSearch {
        
        func dropPinZoomIn(_ placemark: MKPlacemark){
            // cache the pin
            selectedPin = placemark
            // clear existing pins
            mapView.removeAnnotations(mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            print(placemark.name)
            Share.sharedName.nameAdresse = placemark.name

            print(placemark.coordinate)
            
            if let city = placemark.locality,
                let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
                print(city)
                print(state)
            }
            
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    
        
    }
    
extension PopUpAddresseViewController : MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
            
            guard !(annotation is MKUserLocation) else { return nil }
            
            let reuseId = "pin"
            guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView else { return nil }
            
            pinView.pinTintColor = UIColor.orange
            pinView.canShowCallout = true
            let smallSquare = CGSize(width: 30, height: 30)
//            var button: UIButton?
//            button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
//            button?.setBackgroundImage(UIImage(named: "car"), for: UIControl.State())
//            button?.addTarget(self, action: #selector(ViewController.getDirections), for: .touchUpInside)
//            pinView.leftCalloutAccessoryView = button
            
            return pinView
        }

}
