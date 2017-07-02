//
//  CustomColors.swift
//  DB2-chat
//
//  Created by Alexander Slobodjanjuk on 30.06.17.
//  Copyright © 2017 Alexander Slobodjanjuk. All rights reserved.
//

import UIKit

extension UIColor {
    
    
    static func lightBlueColor() -> UIColor {
        return generateColor(74, green: 144, blue: 226, alpha: 1.0)
    }

    static func navyBlueColor() -> UIColor {
        return generateColor(58, green: 79, blue: 152, alpha: 1.0)
    }

    static func middleBlueColor() -> UIColor {
        return generateColor(71, green: 134, blue: 206, alpha: 1.0)
    }
    
    static func generateColor(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
}

