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
    private var _taskDateAndTime: NSDate
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
    
    var taskDateAndTime: Date {
        return _taskDateAndTime as Date
    }
    
    var taskAddress: String {
        return _taskAddress
    }
    
    var taskImage: String {
        return _taskImage
    }
    
    init(name: String, title: String, description: String, date: NSDate, address: String, image: String) {
        self._clientName = name
        self._taskTitle = title
        self._taskDescription = description
        self._taskDateAndTime = date
        self._taskAddress = address
        self._taskImage = image
    }
    
    
}
