//
//  SearchResultCollectionViewCell.swift
//  ficker
//
//  Created by Chenpoting on 2020/2/12.
//  Copyright © 2020 Chenpoting. All rights reserved.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    var isSelect = false
    var image = ""
    let userDefaults = UserDefaults.standard

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = ""
        isSelect = false
        image = ""
    }

    func setupUI(viewModel: PhotoViewModel) {
        iconImageView.kf.indicatorType = .activity
        iconImageView.kf.setImage(with: URL(string: viewModel.image))
        titleLabel.text = viewModel.title
        image = viewModel.image
        checkFavoriteState()
    }
    
    func checkFavoriteState() {
        if let cacheFavorite = userDefaults.value(forKey: "favorite") as? [String: [String: String]],
            let _ = cacheFavorite[image] {
            isSelect = true
            favoriteImageView.image = UIImage(named: "favorite_pink")
        } else {
            isSelect = false
            favoriteImageView.image = UIImage(named: "favorite_white")
        }
    }
    
    func setupSelectUI() {
        var favorite = [String: [String: String]]()
        if let cacheFavorite = userDefaults.value(forKey: "favorite") as? [String: [String: String]] {
            favorite = cacheFavorite
        }
        if isSelect {
            favorite.removeValue(forKey: image)
            isSelect = false
            favoriteImageView.image = UIImage(named: "favorite_white")
        } else {
            favorite[image] = ["image": image, "title": titleLabel.text!]
            isSelect = true
            favoriteImageView.image = UIImage(named: "favorite_pink")
        }
        userDefaults.set(favorite, forKey: "favorite")
        userDefaults.synchronize()
    }
    
}
