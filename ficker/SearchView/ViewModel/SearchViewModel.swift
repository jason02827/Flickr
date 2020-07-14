//
//  SearchViewModel.swift
//  ficker
//
//  Created by Chenpoting on 2020/7/12.
//  Copyright © 2020 Chenpoting. All rights reserved.
//

import UIKit

class SearchViewModel: NSObject {
    
    var checkCompletion: ((Bool) -> Void)?
    
    var search: (keyword: String, pageCount: String) = ("", "") {
        didSet {
            checkFormat()
        }
    }
    
    func checkFormat() {
        if search.keyword.contains(" ") ||
            search.pageCount.contains(" ") ||
            search.keyword.isEmpty ||
            search.pageCount.isEmpty {
            checkCompletion?(false)
        } else {
            if Int(search.pageCount) != nil {
                checkCompletion?(true)
            } else {
                checkCompletion?(false)
            }
        }
    }
    
}
