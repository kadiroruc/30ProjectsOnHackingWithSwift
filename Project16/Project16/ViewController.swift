//
//  ViewController.swift
//  Project16
//
//  Created by Abdulkadir Oruç on 19.08.2023.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate{
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let ankara = Capital(title:"Ankara",coordinate: CLLocationCoordinate2D(latitude: 39.925533, longitude: 32.866287), info: "It is the capital of Türkiye")
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([ankara,london, oslo, paris, rome, washington])
        
        
        let satellite = UIAction(title: "Satellite") { (action) in
            self.mapView.mapType = .satellite
         }
        

         let hybrid = UIAction(title: "Hybrid") { (action) in
             self.mapView.mapType = .hybrid
         }
        
        let standart = UIAction(title: "Standart") { (action) in
            self.mapView.mapType = .standard
        }

        let menu = UIMenu(title: "Map Type", options: .displayInline, children: [satellite , hybrid , standart])
        

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "map"), menu: menu)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self,action: #selector(changeMapType))
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
           guard annotation is Capital else { return nil }

           // 2
           let identifier = "Capital"

           // 3
           var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

           if annotationView == nil {
               //4
               annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
               annotationView?.canShowCallout = true
               // 5
               let btn = UIButton(type: .detailDisclosure)
               annotationView?.rightCalloutAccessoryView = btn
           } else {
               // 6
               annotationView?.annotation = annotation
           }
        annotationView?.pinTintColor = UIColor.systemBlue

           return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        let placeInfo = capital.info

        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    @objc func changeMapType(){
        let ac = UIAlertController(title: "Select Map Type", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Satellite", style: .default,handler: { _ in
            self.mapView.mapType = .satellite
        }))
        present(ac,animated: true)
    }
}


