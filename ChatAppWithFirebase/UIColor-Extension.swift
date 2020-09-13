//
//  UIColor-Extension.swift
//  ChatAppWithFirebase
//
//  Created by 松浦孝太朗 on 2020/09/14.
//  Copyright © 2020 Kotaro. All rights reserved.
//

import UIKit

extension UIColor{
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
