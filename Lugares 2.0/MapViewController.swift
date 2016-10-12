//
//  MapViewController.swift
//  Lugares 2.0
//
//  Created by Rafael Larrosa Espejo on 11/10/16.
//  Copyright © 2016 Rafael Larrosa Espejo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var place : Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(place.name)
        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        self.mapView.showsTraffic = true
        self.mapView.showsScale = true
        self.mapView.showsCompass = true
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(place.location) { [unowned self] (placemarks, error) in
            if error == nil{
                for placemark in placemarks! {
                    let annotation = MKPointAnnotation()
                    annotation.title = self.place.name
                    annotation.coordinate = (placemark.location?.coordinate)!
                    annotation.subtitle = self.place.type
                    
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }else{
              print("Ha habido un error \(error?.localizedDescription)")
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MapViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView : MKPinAnnotationView? = self.mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
        imageView.image = self.place.image
        annotationView?.leftCalloutAccessoryView = imageView
        
        annotationView?.pinTintColor = UIColor.orange
        
        return annotationView
    }
    
}
