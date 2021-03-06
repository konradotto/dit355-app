//
//  ContainerViewController.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-14.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    //MARK: - UI Elements
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet var swipeRecognizer: UISwipeGestureRecognizer!
    
    //MARK: - Composed objects
    lazy var mapVC: UIViewController? = {
        let map = self.storyboard?.instantiateViewController(withIdentifier: "mapView")
        return map
    }()
    lazy var menuVC: UIViewController? = {
        let menu = self.storyboard?.instantiateViewController(withIdentifier: "menuView")
        return menu
    }()
    
    //MARK: - Class Variables
    let blackTransparentViewTag = 666
    var isActive = false

    //MARK: - Managers
    var mqtt: MqttManager!
    var annotationManager: AnnotationManager!
    
    //MARK: - ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        annotationManager = AnnotationManager.shared
        mqtt = MqttManager.shared
        initView()
    }
    
    
    //MARK: - UISetup
    private func initView(){
        self.navigationItem.title = "DIT-355"
        displayMap()
        addShadowToView()
        let btn =  UIBarButtonItem(image: UIImage.init(named: "burgerMenu"), style: .plain, target: self, action: #selector(openOrCloseSideMenu))
        navigationItem.rightBarButtonItem = btn
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeSideMenu), name: Notification.Name(rawValue:"closeMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openSideMenu), name: Notification.Name(rawValue:"openMenu"), object: nil)
        
    }
    private func displayMap(){
        // To display MapViewController in mapView
        if let vc = mapVC {
            self.addChild(vc)
            vc.didMove(toParent: self)
            self.mapView.addSubview(vc.view)
        }
    }
    private func displaySideMenu(){
        // To display SideMenuViewController in menuView
        if !self.children.contains(menuVC!){
            if let vc = menuVC {
                self.addChild(vc)
                vc.didMove(toParent: self)
                vc.view.frame = self.menuView.bounds
                self.menuView.addSubview(vc.view)
                
            }
            
        }
    }
    
    //MARK: - Shadow View
    private func addBlackTransparentView() -> UIView{
        //Black Shadow on MainView(i.e on TabBarController) when side menu is opened.
        let blackView = self.mapVC!.view.viewWithTag(blackTransparentViewTag)
        if blackView != nil{
            return blackView!
        }else{
            let sView = UIView(frame: self.mapVC!.view.bounds)
            sView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            sView.tag = blackTransparentViewTag
            sView.alpha = 0
            sView.backgroundColor = UIColor.black
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(closeSideMenu))
            sView.addGestureRecognizer(recognizer)
            return sView
        }
        
        
    }
    private func addShadowToView(){
        //Gives Illusion that main view is above the side menu
        self.mapView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        self.mapView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.mapView.layer.shadowRadius = 1
        self.mapView.layer.shadowOpacity = 1
        self.mapView.layer.borderColor = UIColor.lightGray.cgColor
        self.mapView.layer.borderWidth = 0.2
    }
    
    
    //MARK: - Selector Methods
    @objc func openOrCloseSideMenu(){
        //Opens or Closes Side Menu On Click of Button
        if isActive{
            //This closes Rear View
            let blackTransparentView = self.view.viewWithTag(self.blackTransparentViewTag)
            UIView.animate(withDuration: 0.3, animations: {
                self.mapVC!.view.frame = CGRect(x: 0, y: 0, width: self.mapView.frame.size.width, height: self.mapView.frame.size.height)
                blackTransparentView?.alpha = 0
                
            }) { (_) in
                blackTransparentView?.removeFromSuperview()
                self.isActive = false
            }
        }else{
            //This opens Rear View
            UIView.animate(withDuration: 0.0, animations: {
                self.displaySideMenu()
                let blackTransparentView = self.addBlackTransparentView()
                
                self.mapVC!.view.addSubview(blackTransparentView)
                
            }) { (_) in
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.addBlackTransparentView().alpha = self.view.bounds.width * 0.6/(self.view.bounds.width * 1.6)
                    self.mapVC!.view.frame = CGRect(x: -(self.mapView.bounds.size.width * 0.6), y: 0, width: self.mapView.frame.size.width, height: self.mapView.frame.size.height)
                    
                }) { (_) in
                    self.isActive = true
                    
                }
            }
            
        }
        
    }
    @objc func closeSideMenu(){
        //To close Side Menu
        let blackTransparentView = self.view.viewWithTag(self.blackTransparentViewTag)
        UIView.animate(withDuration: 0.3, animations: {
            self.mapVC!.view.frame = CGRect(x: 0, y: 0, width: self.mapView.frame.size.width, height: self.mapView.frame.size.height)
            blackTransparentView?.alpha = 0.0
            
        }) { (_) in
            blackTransparentView?.removeFromSuperview()
            self.isActive = false
            
        }
        
    }
    @objc func openSideMenu(){
        UIView.animate(withDuration: 0.0, animations: {
            self.displaySideMenu()
            let blackTransparentView = self.addBlackTransparentView()
            
            self.mapVC!.view.addSubview(blackTransparentView)
            
        }) { (_) in
            UIView.animate(withDuration: 0.3, animations: {
                
                self.addBlackTransparentView().alpha = self.view.bounds.width * 0.6/(self.view.bounds.width * 1.6)
                self.mapVC!.view.frame = CGRect(x: -(self.mapView.bounds.size.width * 0.6), y: 0, width: self.mapView.frame.size.width, height: self.mapView.frame.size.height)
                
            }) { (_) in
                self.isActive = true
                
            }
        }
        
    }
    @IBAction func swipeRecognizerAction(_ sender: Any) {
        closeSideMenu()
    }
   
}
