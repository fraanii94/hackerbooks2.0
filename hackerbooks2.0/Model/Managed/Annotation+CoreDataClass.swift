//
//  Annotation+CoreDataClass.swift
//  hackerbooks2.0
//
//  Created by fran on 28/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import Contacts
public class Annotation: NSManagedObject,CLLocationManagerDelegate {
    
    static let entityName = "Annotation"
    var locationManager : CLLocationManager!
    var hasLocation : Bool{
        get{
            return self.localization == nil
        }
    }
    
    convenience init(pdf:Pdf, inContext context: NSManagedObjectContext){
        self.init(entity: NSEntityDescription.entity(forEntityName: Annotation.entityName, in: context)!, insertInto: context)
        
        self.pdf = pdf
        self.text = "New Note"
        
        self.creationDate = Date() as NSDate?
        self.modificationDate = Date() as NSDate?
    }


}

//MARK: KVO
extension Annotation{
    
    static func observableKeys() ->[String]{return ["text","photo","localization"]}
    func setupKVO(){
        
        // Alta en notificaciones
        
        for key in Annotation.observableKeys(){
           self.addObserver(self, forKeyPath: key, options: .old, context: nil)
        }
        
        
    }
    func tearDownKVO(){
        // Baja en notificaciones
        for key in Annotation.observableKeys(){
            self.removeObserver(self, forKeyPath: key)
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                     of object: Any?,
                    change: [NSKeyValueChangeKey : Any]?,
                   context: UnsafeMutableRawPointer?) {
    //Accion a realizar
        self.modificationDate = Date() as NSDate?
     }
}



//MARK: - lifecycle
extension Annotation{
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setupKVO()
        let status =  CLLocationManager.authorizationStatus()
        if ((status == .authorizedWhenInUse) || (status == .notDetermined)) &&
            CLLocationManager.locationServicesEnabled(){
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
    
    // It is called when the object is searched and when we access to its properties
    public override func awakeFromFetch() {
        super.awakeFromFetch()
        setupKVO()
        
    }
    
    public override func willTurnIntoFault() {
        super.willTurnIntoFault()
        tearDownKVO()
    }
    
}
//MARK: - CLLocation Delegate
extension Annotation{
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        self.locationManager = nil
        
        let _location = locations.last
        
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(_location!) { (placemarks, error) in
            
            let placemark = placemarks?.last
            let addressDictionary = placemark?.addressDictionary
            let address = "\(addressDictionary?["Thoroughfare"])"
            self.localization = Localization(address: address, latitude: (_location?.coordinate.latitude)!, longitude: (_location?.coordinate.longitude)!, annotation: self, inContext: self.managedObjectContext!)
            
        }
        
        
    }
    
}
