//
//  FavoriteViewModel.swift
//  ficker
//
//  Created by Chenpoting on 2020/7/14.
//  Copyright © 2020 Chenpoting. All rights reserved.
//

import UIKit

class FavoriteViewModel: NSObject {

    var loadCompletion: (() -> Void)?
    var photoList = [String: [String: String]]()
    var photoModels = [PhotoModel]()
    
    func getFavoriteContent() {
        photoModels.removeAll()
        let userDefaults = UserDefaults.standard
        if let favorite = userDefaults.value(forKey: "favorite") as? [String : [String : String]] {
            photoList = favorite
        }
        for photo in photoList {
            if let image = photo.value["image"],
                let title = photo.value["title"] {
                let photoModel = PhotoModel()
                photoModel.title = title
                photoModel.image = image
                photoModels.append(photoModel)
            }
        }
        loadCompletion?()
    }
    
}
