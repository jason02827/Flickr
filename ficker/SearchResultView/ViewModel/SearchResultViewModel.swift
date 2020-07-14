//
//  SearchResultViewModel.swift
//  ficker
//
//  Created by Chenpoting on 2020/7/13.
//  Copyright © 2020 Chenpoting. All rights reserved.
//

import UIKit

class SearchResultViewModel: NSObject {

    var loadCompletion: ((String?) -> Void)?
    var keyword = ""
    var pageCount = Int()
    var currentPage = 1
    var totalPages = Int()
    var photoModels = [PhotoModel]()
    
    func loadContent(keyword: String, pageCount: Int, currentPage: Int) {
        let dataManager = DataManager()
        dataManager.request(text: keyword, pageCount: pageCount, page: currentPage) { [weak self] (response, errorString)  in
            do {
                if let interResponse = response {
                    let decodeResponse = try JSONDecoder().decode(PhotoSearchObj.self, from: interResponse)
                    if let photos = decodeResponse.photos,
                        let photoLists = decodeResponse.photos?.photo {
                        if photoLists.count > 0 {
                            self?.contentInfo(info: photos)
                            self?.generateContent(lists: photoLists)
                        } else {
                            self?.loadCompletion?("no content")
                        }
                    }
                } else {
                    self?.loadCompletion?(errorString ?? "response error")
                }
            }
            catch {
                self?.loadCompletion?("download error")
            }
        }
    }
    
    func contentInfo(info: PhotoSearchObj.PhotosObj) {
        if let page = info.page,
            let pages = info.pages {
            currentPage = page
            totalPages = pages
        }
    }
    
    func generateContent(lists: [PhotoSearchObj.PhotoDetailObj]) {
        for list in lists {
            if let farm = list.farm,
                let server = list.server,
                let id = list.id,
                let secret = list.secret,
                let title = list.title {
                let photoModel = PhotoModel()
                photoModel.title = title
                photoModel.image = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
                photoModels.append(photoModel)
            }
        }
        loadCompletion?(nil)
    }
    
}
