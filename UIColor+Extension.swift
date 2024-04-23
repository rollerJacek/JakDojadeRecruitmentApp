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
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}
