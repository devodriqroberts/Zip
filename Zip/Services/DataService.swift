//
//  DataService.swift
//  Zip
//
//  Created by Devodriq Roberts on 7/17/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import Foundation
import Firebase



let DB_BASE = Database.database().reference(fromURL: "https://zipapp-29b5f.firebaseio.com/")

class DataService {
    
    static let instance = DataService()
    
    private var _Ref_BASE = DB_BASE
    
    // Create users directory withing FB DB
    private var _REF_USERS = DB_BASE.child("users")
    
    // Create drivers directory withing FB DB
    private var _REF_DRIVERS = DB_BASE.child("drivers")
    
    // Create trips directory withing FB DB
    private var _REF_TRIPS = DB_BASE.child("trips")
    
    
    //Data encapsulation
    var REF_BASE: DatabaseReference {
        return _Ref_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_DRIVERS: DatabaseReference {
        return _REF_DRIVERS
    }
    
    var REF_TRIPS: DatabaseReference {
        return _REF_TRIPS
    }
    
    func createFirebaseDBUser(uid:String, userData: [String:Any], isDriver: Bool) {
        
        //Check if user is driver and updates user data for appropriate user
        if isDriver {
            REF_DRIVERS.child(uid).updateChildValues(userData) { (error, user) in
                if error != nil {
                    print(error)
                    return
                }
                print("Saved driver data successfully")
            }
        } else {
            REF_USERS.child(uid).updateChildValues(userData) { (error, user) in
                if error != nil {
                    print(error)
                    return
                }
                print("Saved passenger data successfully")
            }
        }
    }
}










