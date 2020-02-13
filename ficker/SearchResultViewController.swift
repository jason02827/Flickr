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
    let dataManager = DataManager()
    var photoList = [[String: String]]()
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        acticityIndicator.startAnimating()
        tabBarController?.tabBar.isHidden = false
        navigationItem.title = "搜尋結果 " + keyword
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SearchResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultCollectionViewCell")

        dataManager.request(text: keyword, pageCount: pageCount) { [weak self] (response) in
            do {
                let decodeResponse = try JSONDecoder().decode(PhotoSearchObj.self, from: response)
                if let photoLists = decodeResponse.photos?.photo {
                    if photoLists.count > 0 {
                        self?.generateContent(lists: photoLists)
                    } else {
                        self?.acticityIndicator.stopAnimating()
                        self?.showAlert(title: "沒有內容")
                    }
                }
            }
            catch {
                self?.showAlert(title: "下載失敗")
            }
        }
    }
    
    func generateContent(lists: [PhotoSearchObj.PhotoDetailObj]) {
        for list in lists {
            if let farm = list.farm,
                let server = list.server,
                let id = list.id,
                let secret = list.secret,
                let title = list.title {
                photoList.append(["image": "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg",
                                  "title": title])
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
        if photoList.count > 0 {
            return photoList.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as? SearchResultCollectionViewCell else { return SearchResultCollectionViewCell() }
        if let image = photoList[indexPath.row]["image"],
            let title = photoList[indexPath.row]["title"] {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: URL(string: image))
            cell.titleLabel.text = title
            cell.favoriteButton.backgroundColor = .systemGray
            cell.isSelect = false
            cell.image = image
            if let cacheFavorite = userDefaults.value(forKey: "favorite") as? [String: [String: String]],
                let _ = cacheFavorite[image] {
                cell.isSelect = true
                cell.favoriteButton.backgroundColor = .systemRed
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SearchResultCollectionViewCell {
            var favorite = [String: [String: String]]()
            if let cacheFavorite = userDefaults.value(forKey: "favorite") as? [String: [String: String]] {
                favorite = cacheFavorite
            }
            if cell.isSelect {
                favorite.removeValue(forKey: cell.image)
                cell.isSelect = false
                cell.favoriteButton.backgroundColor = .systemGray
                
            } else {
                favorite[cell.image] = ["image": cell.image, "title": cell.titleLabel.text!]
                cell.isSelect = true
                cell.favoriteButton.backgroundColor = .systemRed
                
            }
            userDefaults.set(favorite, forKey: "favorite")
            userDefaults.synchronize()
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
