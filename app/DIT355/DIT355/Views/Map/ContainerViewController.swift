//
//  ContainerViewController.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-14.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    //MARK: - ViewController Variables
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var menuView: UIView!
    
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
    
    //MARK: - ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        MapController.shared.dismiss()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    //MARK: - UISetup
    private func initView(){
        displayMap()
        addShadowToView()
        let btn =  UIBarButtonItem(image: UIImage.init(named: "burgerMenu"), style: .plain, target: self, action: #selector(openOrCloseSideMenu))
        navigationItem.rightBarButtonItem = btn
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
                    
                    self.addBlackTransparentView().alpha = self.view.bounds.width * 0.8/(self.view.bounds.width * 1.8)
                    self.mapVC!.view.frame = CGRect(x: -(self.mapView.bounds.size.width * 0.8), y: 0, width: self.mapView.frame.size.width, height: self.mapView.frame.size.height)
                    
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
    
}
