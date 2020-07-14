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
    let viewModel = SearchResultViewModel()
    let toast = Toast()

    override func viewDidLoad() {
        super.viewDidLoad()
        acticityIndicator.startAnimating()
        tabBarController?.tabBar.isHidden = false
        navigationItem.title = "搜尋結果 " + keyword
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SearchResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.loadCompletion = { [weak self] (error) in
            if let error = error {
                self?.toast.showToast(text: error, view: self!.view)
            } else {
                self?.collectionView.reloadData()
            }
            self?.acticityIndicator.stopAnimating()
        }
        viewModel.loadContent(keyword: keyword, pageCount: pageCount, currentPage: 1)
    }
    
}

//MARK: - CollectionView Delegate
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SearchResultCollectionViewCell {
            cell.setupSelectUI()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.photoModels.count - 2 &&
            viewModel.currentPage + 1 <= viewModel.totalPages {
            viewModel.loadContent(keyword: keyword, pageCount: pageCount, currentPage: viewModel.currentPage + 1)
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
