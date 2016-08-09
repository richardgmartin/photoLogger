//
//  StyleView.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-08-09.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit

class DropBoxView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
    }

}
