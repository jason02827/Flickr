//
//  Alert.swift
//  ficker
//
//  Created by Chenpoting on 2020/2/13.
//  Copyright © 2020 Chenpoting. All rights reserved.
//

import UIKit

class Alert: NSObject {

    func alertWithSelfViewController(viewController: UIViewController,
                                     title: String,
                                     message: String,
                                     confirmTitle: String,
                                     cancelTitle: String,
                                     confirmCompletionHandler: @escaping () -> Void,
                                     cancelCompletionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: confirmTitle, style: .default, handler: { (action) in
            confirmCompletionHandler()
        })
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { (action) in
            cancelCompletionHandler()
        })
        alertController.addAction(okAction)
        if cancelTitle != "" {
            alertController.addAction(cancelAction)
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
