//
//  DataService.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-08-22.
//  Copyright © 2016 richard martin. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

// file contains references to firebase database endpoints

class DataService {
    
    // create a single instance of type DataService :: singleton
    
    static let ds = DataService()
    
    // reference endpoints for database
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    // custom func to create user in firebase database
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
}
