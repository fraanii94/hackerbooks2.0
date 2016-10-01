//
//  NotesMapViewController.swift
//  hackerbooks2.0
//
//  Created by fran on 25/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import UIKit
import MapKit
class NotesMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let annotations : [Annotation]
    
    init(annotations : [Annotation]){
        self.annotations = annotations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.title = "Map"
        synchronizeMap()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showNote(){
        
        
    }
    
    func synchronizeMap(){
        
        for annotation in self.annotations{
            let pin = CustomPointAnnotation()
            pin.title = annotation.text
            pin.image = annotation.photo?.image
            pin.coordinate = CLLocationCoordinate2D(latitude: (annotation.localization?.latitude)!, longitude: (annotation.localization?.longitude)!)
            
            mapView.addAnnotation(pin)
            
        }
        
    }

}

extension NotesMapViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotation = annotation as! CustomPointAnnotation
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pin.canShowCallout = true
        let noteButton = UIButton(type: .infoLight)
        noteButton.addTarget(self, action: #selector(showNote), for: .touchUpInside)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView.image = annotation.image!
    
        pin.rightCalloutAccessoryView = imageView
        
        return pin
    }
    
}
