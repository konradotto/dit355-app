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
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var subscribeButton: UIButton!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private lazy var topicsArray = ["new","travel_requests","travel_requests/long_trips","travel_requests/short_trips","external"]
    
    private lazy var mqtt = MqttManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
    }
    
    @IBAction func connectButtonAction(_ sender: Any) {
        if connectButton.titleLabel?.text == "Connect"{
            if !hostTextField.text!.isEmpty{
                if !portTextField.text!.isEmpty{
                    let host = hostTextField.text!
                    let port = UInt16(portTextField.text!) ?? 1883
                    let _ = mqtt.establishConnection(host: host, port: port)
                }
            }
        }
        else{
            mqtt.disconnect()
            self.connectButton.setTitle("Connect", for: .normal)
        }
        loadingIndicator.startAnimating()
    }
    
    
    @IBAction func subscribeButtonAction(_ sender: Any) {
        
        if !topicTextField.text!.isEmpty{
            let topic = topicTextField.text!
            if subscribeButton.titleLabel?.text == "Subscribe" {
                mqtt.subscribeTopic(topic: topic)
                self.subscribeButton.setTitle("Unsubscribe", for: .normal)
            }
            else {
                mqtt.unsubscribeTopic(topic: topic)
                self.subscribeButton.setTitle("Subscribe", for: .normal)
            }
        }
    }
    @IBAction func doneButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    
    func initView(){
        self.holderView.layer.cornerRadius = 10
        self.doneButton.layer.cornerRadius = 10
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
        topicTextField.isHidden = true
        portTextField.keyboardType = .numberPad
        scrollView.keyboardDismissMode = .onDrag
        pickerView.layer.cornerRadius = 5
        connectButton.layer.cornerRadius = 10
        subscribeButton.layer.cornerRadius = 10
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateButtons(notification:)), name: Notification.Name(rawValue:"mqtt_status"), object: nil)
    }
    @objc func topicTextField_EditingChanged(){
        print("row: ",pickerView.selectedRow(inComponent: 0))
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
    
    @objc func updateButtons(notification: NSNotification){
        if let userInfo = notification.userInfo {
            if let isConnected = userInfo["isConnected"] as? Bool {
                if isConnected{
                    DispatchQueue.main.async {
                        self.loadingIndicator.stopAnimating()
                        self.connectButton.setTitle("Disconnect", for: .normal)
                        self.subscribeButton.isEnabled = true
                        
                    }
                    
                }
                else{
                    DispatchQueue.main.async{
                        self.loadingIndicator.stopAnimating()
                        self.connectButton.setTitle("Connect", for: .normal)
                        self.subscribeButton.isEnabled = false
                    }
                    
                }
            }
        }
        
        
        
    }
    
    func checkFields(){
        if !mqtt.isConnected{
            subscribeButton.isEnabled = false
        }
        let host    = mqtt.host
        let port    = mqtt.port
        let topic   = mqtt.topic
        if !host.isEmpty{
            self.hostTextField.text = host
            self.portTextField.text = String(port)
            if mqtt.isConnected{
                self.connectButton.setTitle("Disconnect", for: .normal)
            }
        }
        print(">> topic: ",topic)
        if !topic.isEmpty{
            self.pickerView.isHidden = true
            topicTextField.isHidden = false
            self.topicTextField.text = topic
            if mqtt.isSubscribed{
                self.subscribeButton.setTitle("Unsubscribe", for: .normal)
            }
            
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
