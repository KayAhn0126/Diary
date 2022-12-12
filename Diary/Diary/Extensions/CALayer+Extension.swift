//
//  CALayer+Extension.swift
//  Diary
//
//  Created by Kay on 2022/12/12.
//

import UIKit
import Foundation
import QuartzCore

extension CALayer {
    func settingBorderWithOptions(color: UIColor, width: CGFloat, cornerRadius: CGFloat) {
        self.borderColor = color.cgColor
        self.borderWidth = width
        self.cornerRadius = cornerRadius
    }
}
