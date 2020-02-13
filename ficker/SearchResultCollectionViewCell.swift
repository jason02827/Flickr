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
    @IBOutlet weak var favoriteButton: UIButton!
    var isSelect = false
    var image = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }    

}
