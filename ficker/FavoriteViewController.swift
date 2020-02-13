//
//  FavoriteViewController.swift
//  ficker
//
//  Created by Chenpoting on 2020/2/13.
//  Copyright © 2020 Chenpoting. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var photoList = [String: [String: String]]()
    var photoListArray = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SearchResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoListArray.removeAll()
        let userDefaults = UserDefaults.standard
        if let favorite = userDefaults.value(forKey: "favorite") as? [String : [String : String]] {
            photoList = favorite
        }
        for photo in photoList {
            if let image = photo.value["image"],
                let title = photo.value["title"] {
                photoListArray.append(["image": image, "title": title])
            }
        }
        collectionView.reloadData()
    }
    
}

//MARK: - CollectionView Delegate
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoListArray.count > 0 {
            return photoListArray.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as? SearchResultCollectionViewCell else { return SearchResultCollectionViewCell() }
        if let image = photoListArray[indexPath.row]["image"],
            let title = photoListArray[indexPath.row]["title"] {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: URL(string: image))
            cell.titleLabel.text = title
            cell.favoriteButton.isHidden = true
        }
        return cell
    }
    
}

//MARK: - CollectionView FlowLayoutDelegate
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    
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



