//
//  Post.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-07-20.
//  Copyright © 2016 richard martin. All rights reserved.
//

import Foundation

class Post {
    
    // declare Post vars as Private and as getters
    
    private var _clientName: String
    private var _taskTitle: String
    private var _taskDescription: String
    private var _taskDate: String
    private var _taskAddress: String
    private var _taskImage: String       //assume var is a String type to comply with Firebase :: for now
    
    var clientName: String {
        return _clientName
    }
    
    var taskTitle: String {
        return _taskTitle
    }
    
    var taskDescription: String {
        return _taskDescription
    }
    
    var taskDate: String {
        return _taskDate
    }
    
//    var dateString: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dateString = dateFormatter.string(from: _taskDate as Date)
//        return dateString
//    }
    
    var taskAddress: String {
        return _taskAddress
    }
    
    var taskImage: String {
        return _taskImage
    }
    
    init(name: String, title: String, description: String, date: String, address: String, image: String) {
        self._clientName = name
        self._taskTitle = title
        self._taskDescription = description
        self._taskDate = date
        self._taskAddress = address
        self._taskImage = image
        
        // convert taskDate to a String
        
        
        
    }
    
    convenience init() {
        
        self.init(name: "", title: "", description: "", date: "", address: "", image: "")
    }
    
    
    
}
