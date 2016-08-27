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
    
    private var _clientName: String!
    private var _taskTitle: String!
    private var _taskDescription: String!
    private var _taskDate: String!
    private var _taskAddress: String!
    private var _taskImage: String!
    private var _postKey: String!
    
    var clientName: String {
        if _clientName == nil {
            _clientName = ""
        }
         return _clientName
     }
    
    var taskTitle: String {
        if _taskTitle == nil {
            _taskTitle = ""
        }
        return _taskTitle
    }
    
    var taskDescription: String {
        if _taskDescription == nil {
            _taskDescription = ""
        }
        return _taskDescription
    }
    
    var taskDate: String {
        if _taskDate == nil {
            _taskDate = ""
        }
        return _taskDate
     }
    
//    var dateString: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dateString = dateFormatter.string(from: _taskDate as Date)
//        return dateString
//    }
    
     var taskAddress: String {
        if _taskAddress == nil {
            _taskAddress = ""
        }
         return _taskAddress
     }
    
     var taskImage: String {
        if _taskImage == nil {
            _taskImage = ""
        }
         return _taskImage
     }
    
    var postKey: String {
        return _postKey
    }
    
    init(name: String, title: String, desc: String, date: String, address: String, image: String) {
        self._clientName = name
        self._taskTitle = title
        self._taskDescription = desc
        self._taskDate = date
        self._taskAddress = address
        self._taskImage = image
    }
    
    init(postKey: String, postData: Dictionary<String, String>) {
            
        self._postKey = postKey
            
        if let clientName = postData["clientName"] {
            self._clientName = clientName
        }
            
        if let taskTitle = postData["taskTitle"] {
            self._taskTitle = taskTitle
        }
            
        if let taskDescription = postData["taskDescription"] {
            self._taskDescription = taskDescription
        }
            
        if let taskDate = postData["taskDate"] {
            self._taskDate = taskDate
        }
            
        if let taskAddress = postData["taskAddress"] {
            self._taskAddress = taskAddress
        }
            
        if let taskImage = postData["taskImage"] {
            self._taskImage = taskImage
        }
    }
}
