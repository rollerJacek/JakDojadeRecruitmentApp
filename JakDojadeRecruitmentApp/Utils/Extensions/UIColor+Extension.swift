//
//  UIColor+Extension.swift
//  JakDojadeRecruitmentApp
//
//  Created by Jacek Stąporek on 23/04/2024.
//

import UIKit

extension UIColor {
    static let navbarBackground = UIColor(hex: "#282641")
    static let mainFont = UIColor(hex: "#303030")
    static let contentPositive = UIColor(hex: "#0A9F6A")
    static let mainBackground = UIColor(hex: "#F6F6F6")
    static let cellBackground = UIColor(hex: "#FFFFFF")
    static let routeColor = UIColor(hex: "#264AFF")
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x0000_00FF
        let red = CGFloat(Int(color >> 16) & mask) / 255.0
        let green = CGFloat(Int(color >> 8) & mask) / 255.0
        let blue = CGFloat(Int(color) & mask) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
