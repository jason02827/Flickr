//
//  SearchViewController.swift
//  ficker
//
//  Created by Chenpoting on 2020/2/13.
//  Copyright © 2020 Chenpoting. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    let viewModel = SearchViewModel()
    let toast = Toast()
    var centerConstraint: Constraint?
    var keywordTextField = UITextField()
    var pageCountTextField = UITextField()
    var searchButton = UIButton()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setTextFieldObservable()
        keywordTextField.delegate = self
        pageCountTextField.delegate = self
        bindViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        checkSearchButton(isShow: false)
        keywordTextField.text = ""
        pageCountTextField.text = ""
    }

    func bindViewModel() {
        viewModel.checkCompletion = { [weak self] (isShow) in
            if !isShow {
                self?.toast.showToast(text: "含有空白或其他格式錯誤", view: self!.view)
            }
            self?.checkSearchButton(isShow: isShow)
        }
    }
    
    func setupUI() {
        navigationItem.title = "搜尋輸入頁"
        keywordTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        keywordTextField.placeholder = "欲搜尋內容"
        textFieldUI(textField: keywordTextField)
        
        pageCountTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        pageCountTextField.placeholder = "每頁呈現數量"
        pageCountTextField.keyboardType = .numberPad
        textFieldUI(textField: pageCountTextField)
        
        searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        searchButton.setTitle("搜尋", for: .normal)
        searchButton.setBackgroundImage(UIColor.systemBlue.image(), for: .normal)
        searchButton.setBackgroundImage(UIColor.systemGray.image(), for: .disabled)
        searchButton.addTarget(self, action: #selector(searchButtonClick), for: .touchUpInside)
        
        view.addSubview(keywordTextField)
        view.addSubview(pageCountTextField)
        view.addSubview(searchButton)
        
        keywordTextField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.height.equalTo(34)
            make.bottom.equalTo(pageCountTextField).offset(-54)
        }
        pageCountTextField.snp.makeConstraints { (make) in
            pageCountTextFieldConstraints(make: make)
        }
        searchButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.height.equalTo(34)
            make.top.equalTo(pageCountTextField).offset(54)
        }
    }
    
    func setTextFieldObservable() {
        keywordTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self] (text) in
                self?.viewModel.keyword = text
            }, onDisposed: {})
            .disposed(by: disposeBag)
        
        pageCountTextField.rx.text.orEmpty.asObservable()
            .subscribe(onNext: { [weak self] (text) in
                self?.viewModel.pageCount = Int(text)
            }, onDisposed: {})
            .disposed(by: disposeBag)
    }
    
    func pageCountTextFieldConstraints(make: ConstraintMaker) {
        make.leading.equalToSuperview().offset(40)
        make.trailing.equalToSuperview().offset(-40)
        make.height.equalTo(34)
        make.center.equalToSuperview()
    }
    
    func textFieldUI(textField: UITextField) {
        textField.layer.cornerRadius = 4
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 10, height: 1))
    }
    
    @objc func searchButtonClick() {
        guard let keyword = viewModel.keyword else { return }
        guard let pageCount = viewModel.pageCount else { return }
        let vc = SearchResultViewController()
        vc.keyword = keyword
        vc.pageCount = pageCount
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            if intersection.height > 0 {
                pageCountTextField.snp.makeConstraints { (make) in
                    make.center.equalToSuperview().offset(-40)
                }
                checkSearchButton(isShow: false)
            }
            else {
                pageCountTextField.snp.remakeConstraints { (make) in
                    pageCountTextFieldConstraints(make: make)
                }
                viewModel.checkFormat()
            }
            UIView.animate(withDuration: duration,
                           delay: 0.1,
                           options: UIView.AnimationOptions(rawValue: curve),
                           animations: {
                            self.view.layoutIfNeeded()
            },
                           completion: nil)
        }
    }
    
    func checkSearchButton(isShow: Bool) {
        if isShow {
            searchButton.isEnabled = true
            searchButton.backgroundColor = UIColor.systemBlue
        }
        else {
            searchButton.isEnabled = false
            searchButton.backgroundColor = UIColor.systemGray
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if keywordTextField.isFirstResponder {
            keywordTextField.resignFirstResponder()
        }
        if pageCountTextField.isFirstResponder {
            pageCountTextField.resignFirstResponder()
        }
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == keywordTextField {
            pageCountTextField.becomeFirstResponder()
        } else {
            pageCountTextField.resignFirstResponder()
        }
        return true
    }
    
}
