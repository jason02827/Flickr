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
                 page: Int,
                 completionHandler: @escaping (Data?, String?) -> Void) {
        let urlString = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=0182f0b279dfa7f2cd2dee294d4b58db&text=\(text)&per_page=\(pageCount)&page=\(page)&format=json&nojsoncallback=1"
        if let urlEncode = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlEncode) {
            Alamofire.request(url).response { (response) in
                if response.error == nil {
                    completionHandler(response.data, nil)
                }
                else {
                    completionHandler(nil, response.error?.localizedDescription)
                }
            }
        } else {
            print("url: \(urlString)")
            completionHandler(nil, "search error")
        }
    }
    
}
