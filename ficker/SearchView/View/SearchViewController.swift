//
//  SearchViewController.swift
//  ficker
//
//  Created by Chenpoting on 2020/2/13.
//  Copyright © 2020 Chenpoting. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var pageCountTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
        
    let viewModel = SearchViewModel()
    let toast = Toast()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self?.toast.showToast(text: "格式錯誤", view: self!.view)
            }
            self?.checkSearchButton(isShow: isShow)
        }
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            if intersection.height > 0 {
                centerYConstraint.constant = -50
                checkSearchButton(isShow: false)
            }
            else {
                centerYConstraint.constant = 0
                viewModel.search = (keywordTextField.text ?? " ",
                                    pageCountTextField.text ?? " ")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SearchResultViewController,
            let keyword = keywordTextField.text,
            let pageCount = pageCountTextField.text,
            let pageCountInt = Int(pageCount) {
            vc.keyword = keyword
            vc.pageCount = pageCountInt
        } else {
            toast.showToast(text: "格式錯誤", view: view)
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
