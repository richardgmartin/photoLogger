//
//  StyleDescriptionBox.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-08-24.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit

class StyleDescriptionBox: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.3).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
        
    }
    


}
