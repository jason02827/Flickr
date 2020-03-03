//
//  SearchResultViewController.swift
//  ficker
//
//  Created by Chenpoting on 2020/2/11.
//  Copyright © 2020 Chenpoting. All rights reserved.
//

import UIKit
import Kingfisher

class SearchResultViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var acticityIndicator: UIActivityIndicatorView!
    
    var keyword = ""
    var pageCount = Int()
    var currentPage = 1
    var totalPages = Int()
    let dataManager = DataManager()
    var photoViewModels = [PhotoViewModel]()
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        acticityIndicator.startAnimating()
        tabBarController?.tabBar.isHidden = false
        navigationItem.title = "搜尋結果 " + keyword
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SearchResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        loadContent(currentPage: 1)
    }
    
    func loadContent(currentPage: Int) {
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
                            self?.acticityIndicator.stopAnimating()
                            self?.showAlert(title: "no content")
                        }
                    }
                } else {
                    self?.showAlert(title: errorString ?? "response error")
                }
            }
            catch {
                self?.showAlert(title: "download error")
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
                let photoViewModel = PhotoViewModel()
                photoViewModel.title = title
                photoViewModel.image = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
                photoViewModels.append(photoViewModel)
            }
        }
        collectionView.reloadData()
        acticityIndicator.stopAnimating()
    }
    
    func showAlert(title: String) {
        let alert = Alert()
        alert.alertWithSelfViewController(viewController: self,
                                          title: title,
                                          message: "",
                                          confirmTitle: "確定",
                                          cancelTitle: "",
                                          confirmCompletionHandler: {},
                                          cancelCompletionHandler: {})
    }
    
}

//MARK: - CollectionView Delegate
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoViewModels.count > 0 {
            return photoViewModels.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as? SearchResultCollectionViewCell else { return SearchResultCollectionViewCell() }
        cell.setupUI(viewModel: photoViewModels[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SearchResultCollectionViewCell {
            cell.setupSelectUI()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photoViewModels.count - 2 &&
            currentPage + 1 <= totalPages {
            loadContent(currentPage: currentPage + 1)
            let toast = Toast()
            toast.showToast(text: "繼續載入下一頁", view: view)
        }
    }
    
}

//MARK: - CollectionView FlowLayoutDelegate
extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 40) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}
