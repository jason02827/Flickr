//
//  DataManager.swift
//  ficker
//
//  Created by Chenpoting on 2020/2/12.
//  Copyright © 2020 Chenpoting. All rights reserved.
//

import UIKit
import Alamofire

class DataManager: NSObject {

    func request(text: String,
                 pageCount: Int,
                 completionHandler: @escaping (Data) -> Void) {
        let urlString = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=0182f0b279dfa7f2cd2dee294d4b58db&text=\(text)&per_page=\(pageCount)&format=json&nojsoncallback=1"
        if let url = URL(string: urlString) {
            Alamofire.request(url).response { (response) in
                if response.error == nil {
                    completionHandler(response.data!)
                }
                else {
                    //                self.httpError(errorString: response.error?.localizedDescription ?? "debug httpsGetRequest error")
                }
            }
        }
    }
    
}
//https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=0182f0b279dfa7f2cd2dee294d4b58db&text=%E7%BE%8E%E9%A3%9F&per_page=10&format=json&nojsoncallback=1
