//
//  TravelMapViewController.swift
//  Virtual Tourist
//
//  Created by Bashayer AlGhamdi on 22/01/2019.
//  Copyright © 2019 Bashayer. All rights reserved.
//

import UIKit
import MapKit

class TravelMapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var footerView: UIView!
    
    var pinAnnotation: MKPointAnnotation? = nil
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        navigationItem.rightBarButtonItem = editButtonItem
        footerView.isHidden = true
        
        if let pins = loadPins() {
            displayPins(pins)
        }
    }
    
    func showInfo(withTitle: String = "Info", withMessage: String, action: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                action?()
            }))
            self.present(ac, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PhotoAlbumViewController {
            guard let pin = sender as? Pin else {
                return
            }
            let c1 = segue.destination as! PhotoAlbumViewController
            c1.pin = pin
        }
    }
    
    
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: mapView)
        let locCoord = mapView.convert(location, toCoordinateFrom: mapView)
        
        if sender.state == .began {
            
            pinAnnotation = MKPointAnnotation()
            pinAnnotation!.coordinate = locCoord
            
            print("\(locCoord.latitude)")
            print("\(locCoord.longitude)")
        
            mapView.addAnnotation(pinAnnotation!)
            
        } else if sender.state == .changed {
            pinAnnotation!.coordinate = locCoord
        } else if sender.state == .ended {
            
            _ = Pin(
                latitude: String(pinAnnotation!.coordinate.latitude),
                longitude: String(pinAnnotation!.coordinate.longitude),
                context: DataController.shared().context
            )
             appDelegate.saveViewContext()
            
        }
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        footerView.isHidden = !editing
    }
    

    func displayPins(_ pins: [Pin]) {
        for pin in pins where pin.latitude != nil && pin.longitude != nil {
            let annotation = MKPointAnnotation()
            let lat = Double(pin.latitude!)!
            let lon = Double(pin.longitude!)!
            annotation.coordinate = CLLocationCoordinate2DMake(lat, lon)
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    
    private func loadPins() -> [Pin]? {
        var pins: [Pin]?
        do {
            try pins = DataController.shared().fetchAllPins(entityName: Pin.name)
        } catch {
            showInfo(withTitle: "Error", withMessage: "Error found while fetching Pin locations")
        }
        return pins
    }
    
    private func loadPin(latitude: String, longitude: String) -> Pin? {
        let predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", latitude, longitude)
        var pin: Pin?
        do {
            try pin = DataController.shared().fetchPin(predicate, entityName: Pin.name)
        } catch {
            showInfo(withTitle: "Error", withMessage: "Error found while fetching the location")
        }
        return pin
    }
    


}


extension TravelMapViewController {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
            pinView!.animatesDrop = true
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            self.showInfo(withMessage: "No link defined.")
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else {
            return
        }

        mapView.deselectAnnotation(annotation, animated: true)
        print("\(annotation.coordinate.latitude)")
        print("\(annotation.coordinate.longitude)")
        
        let lat = String(annotation.coordinate.latitude)
        let lon = String(annotation.coordinate.longitude)
        if let pin = loadPin(latitude: lat, longitude: lon) {
            if isEditing {
                mapView.removeAnnotation(annotation)
                DataController.shared().context.delete(pin)
                appDelegate.saveViewContext()
                return
            }
            performSegue(withIdentifier: "showAlbum", sender: pin)
        }
    }
}
