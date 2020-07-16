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
    
    let viewModel = FavoriteViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的最愛"
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SearchResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavoriteContent()
        tabBarController?.tabBar.isHidden = false
    }
    
    func bindViewModel() {
        viewModel.loadCompletion = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

//MARK: - CollectionView Delegate
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.photoModels.count > 0 {
            return viewModel.photoModels.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as? SearchResultCollectionViewCell else { return SearchResultCollectionViewCell() }
        cell.setupUI(model: viewModel.photoModels[indexPath.row])
        cell.favoriteImageView.isHidden = true
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
