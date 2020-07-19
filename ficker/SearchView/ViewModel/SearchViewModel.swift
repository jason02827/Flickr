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
    var keyword: String?
    var pageCount: Int?
    
    func checkFormat() {
        if let keyword = keyword,
            let _ = pageCount {
            if keyword.contains(" ") || keyword.isEmpty {
                checkCompletion?(false)
            } else {
                checkCompletion?(true)
            }
        } else {
            checkCompletion?(false)
        }
    }
    
}
