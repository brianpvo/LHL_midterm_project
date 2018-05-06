//
//  User.swift
//  HeadsUp
//
//  Created by Brian Vo on 2018-05-02.
//  Copyright © 2018 Brian Vo & Ray Lin. All rights reserved.
//

import UIKit
import Firebase
import GeoFire

class User: NSObject, MKAnnotation {
    
    var name: String
    var coordinate: CLLocationCoordinate2D
    var matchedUserUUID: String?
    var geofireRef: DatabaseReference
    var geoFire: GeoFire
    var isObserving = false
    var isStarted = false
    var email: String?
    var profileImageUrl: String?
    var phoneNumber: String?
    
    init(name: String, email: String?, profileImageUrl: String?, phoneNumber: String?, coordinate: CLLocationCoordinate2D) {
        self.name = name;
        self.coordinate = coordinate;
//        self.isMatched = false
        self.email = email
        self.phoneNumber = phoneNumber
        self.profileImageUrl = profileImageUrl
        self.geofireRef = Database.database().reference()
        self.geoFire = GeoFire(firebaseRef: self.geofireRef.child("User_Location"))
    }
    
    func saveLocGeoFire(uuid: String) {
        self.geofireRef.child("Users").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(uuid){
                
            } else {
                self.geofireRef.child("Users").child(uuid).updateChildValues(["name": self.name])
                print("false uuid doesnt exist")
            }
        }
        
        geoFire.setLocation(CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude), forKey: uuid) { (error) in
            if (error != nil) {
                print("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
                print("uuid: \(uuid)")
            }
        }
        
    }
    
    func retrieveLocGeoFire(uuid: String) {
        self.geoFire.getLocationForKey(uuid) { (location, error) in
            if (error != nil) {
                print("An error occurred getting the location for \"user-location\": \(error?.localizedDescription)")
            } else if (location != nil) {
                print("Location for \"user-location\" is [\(location?.coordinate.latitude), \(location?.coordinate.longitude)]")
            } else {
                print("GeoFire does not contain a location for \"user-location\"")
            }
        }
        
    }

}
