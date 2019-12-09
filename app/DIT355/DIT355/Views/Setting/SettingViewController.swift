//
//  SettingViewController.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-12-09.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private lazy var topicsArray = [String]()
    
    private lazy var mqtt = MqttManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func initView(){
        self.holderView.layer.cornerRadius = 10
        self.cancelButton.layer.cornerRadius = 10
        self.saveButton.layer.cornerRadius = 10
        topicTextField.delegate = self
        hostTextField.delegate = self
        portTextField.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        hostTextField.returnKeyType = .done
        portTextField.returnKeyType = .done
        topicTextField.returnKeyType = .done
        hostTextField.enablesReturnKeyAutomatically = true
        portTextField.enablesReturnKeyAutomatically = true
        topicTextField.enablesReturnKeyAutomatically = true
        hostTextField.clearsOnBeginEditing = true
        portTextField.clearsOnBeginEditing = true
        topicTextField.addTarget(self, action: #selector(topicTextField_EditingChanged), for: .editingChanged)
        topicTextField.addTarget(self, action: #selector(emptyTextField_EditingEnded), for: .editingDidEnd)
        hostTextField.addTarget(self, action: #selector(emptyTextField_EditingEnded), for: .editingDidEnd)
        portTextField.addTarget(self, action: #selector(emptyTextField_EditingEnded), for: .editingDidEnd)
        topicsArray.append("new")
        topicsArray.append("travel_requests")
        topicsArray.append("external")
        topicsArray.append("travel_requests/long_trips")
        topicsArray.append("travel_requests/short_trips")
        topicTextField.isHidden = true
        
        scrollView.keyboardDismissMode = .onDrag
        pickerView.layer.cornerRadius = 5
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    @objc func topicTextField_EditingChanged(){
        if topicTextField.text == "" {
            topicTextField.isHidden = true
            pickerView.isHidden = false
            
        }
        
    }
    @objc func emptyTextField_EditingEnded(){
        if hostTextField.text == ""{
            hostTextField.text = "Enter the host url"
        }
        else if portTextField.text == "" {
            portTextField.text = "Enter the port"
        }
        else if !topicTextField.isHidden && topicTextField.text == "" {
            topicTextField.isHidden = true
            pickerView.isHidden = false
        }
        
    }
   
   
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if bottomConstraint.constant == 0 {
                bottomConstraint.constant += keyboardSize.height
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if bottomConstraint.constant != 0 {
            bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    
    
}
extension SettingViewController: UITextFieldDelegate {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
}
extension SettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({

            $0.isHidden = $0.frame.height < 1.0
        })
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.topicsArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return topicsArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if topicsArray[row] == "new" {
            if topicTextField.canBecomeFirstResponder{
                pickerView.isHidden = true
                topicTextField.isHidden = false
                topicTextField.becomeFirstResponder()
                return
            }
            
        }
        pickerView.isHidden = true
        topicTextField.isHidden = false
        topicTextField.text = topicsArray[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str = topicsArray[row]
        return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
    }
    
    
}
