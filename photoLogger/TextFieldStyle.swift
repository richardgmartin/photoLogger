//
//  TextFieldStyle.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-08-28.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit

class TextFieldStyle: NSObject {

    let view:UITextField
    
    init(_ view:UITextField) {
        
        self.view = view

        self.view.layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.3).cgColor
        self.view.layer.borderWidth = 1.0
        self.view.layer.cornerRadius = 2.0
    }
    
}
