//
//  Toast.swift
//  ficker
//
//  Created by Chenpoting on 2020/3/2.
//  Copyright © 2020 Chenpoting. All rights reserved.
//

import UIKit

class Toast: NSObject {
    
    func showToast(text: String, view: UIView) {
        let toastLabel = UILabel()
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = .white
        DispatchQueue.main.async {
            toastLabel.layer.cornerRadius = toastLabel.bounds.height / 2
        }
        toastLabel.textAlignment = .center
        toastLabel.font = .systemFont(ofSize: 15)
        toastLabel.text = text
        toastLabel.layer.masksToBounds = true
        
        let maxSize = CGSize(width: view.bounds.width - 40, height: view.bounds.height)
        var expectedSize = toastLabel.sizeThatFits(maxSize)
        var lbWidth = maxSize.width
        var lbHeight = maxSize.height
        if maxSize.width >= expectedSize.width{
            lbWidth = expectedSize.width
        }
        if maxSize.height >= expectedSize.height{
            lbHeight = expectedSize.height
        }
        expectedSize = CGSize(width: lbWidth, height: lbHeight)
        
        toastLabel.frame = CGRect(x: ((view.bounds.size.width)/2) - ((expectedSize.width + 60)/2),
                                  y: (view.bounds.height / 2) - expectedSize.height - 40 - 20,
                                  width: expectedSize.width + 60,
                                  height: expectedSize.height + 20)
        DispatchQueue.main.async {
            view.addSubview(toastLabel)
            UIView.animate(withDuration: 2, delay: 2, options: [], animations: {
                toastLabel.alpha = 0
            }) { (completion) in
                toastLabel.removeFromSuperview()
            }
        }
    }
    
}
