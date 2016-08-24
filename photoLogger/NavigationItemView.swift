//
//  NavigationItemView.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-08-24.
//  Copyright © 2016 richard martin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
}

class NavigationItemView: UINavigationController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set background color of navigation bar item
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 120, green: 144, blue: 156)
        
        /*  working code to replace photologger text with (scaled) photologger logo
         
         let logo = UIImage(named: "photo-logger-logo-white")
         let newSize = CGSize(width: (logo?.size.width)! / 2, height: (logo?.size.height)! / 2)
         let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
         logo?.draw(in: rect)
         
         let phLogo = UIImageView(image:logo)
         self.navigationItem.titleView = phLogo
         self.navigationItem.titleView?.contentMode = .scaleAspectFit
         
         */

        
    }
    
}
