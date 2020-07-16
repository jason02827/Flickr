//
//  ColorExtension.swift
//  ficker
//
//  Created by Chenpoting on 2020/7/16.
//  Copyright © 2020 Chenpoting. All rights reserved.
//

import UIKit

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
