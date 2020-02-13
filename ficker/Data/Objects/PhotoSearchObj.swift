//
//  PhotoSearchObj.swift
//  ficker
//
//  Created by Chenpoting on 2020/2/12.
//  Copyright © 2020 Chenpoting. All rights reserved.
//

import UIKit

struct PhotoSearchObj: Codable {
    let photos: PhotosObj?
    let stat: String?

    struct PhotosObj: Codable {
        let page: Int?
        let pages: Int?
        let perpage: Int?
        let total: String?
        let photo: [PhotoDetailObj]
    }
    
    struct PhotoDetailObj: Codable {
        let farm: Int?
        let secret: String?
        let id: String?
        let server: String?
        let title: String?
    }
    
}
