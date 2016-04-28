//
//  UIColor+Init.swift
//  StateMachineSwiftTest
//
//  Created by AndrewPetrov on 4/27/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation

extension UIColor {
    
    convenience init(rgbColorCodeRed red: Int, green: Int, blue: Int, alpha: CGFloat) {
        let redPart = CGFloat(red) / 255
        let greenPart = CGFloat(green) / 255
        let bluePart = CGFloat(blue) / 255
        
        self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alpha)
    }
}
