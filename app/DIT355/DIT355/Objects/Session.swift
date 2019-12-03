//
//  RequestSession.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-14.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation


class Session: NSObject {
    
    var id : String
    var title : String
    var date : Date
    var annotations: [Annotation]
    
    
    override public init() {
        self.id = UUID().uuidString
        self.title = String()
        self.date = Date()
        self.annotations = [Annotation]()
    }
    
    public init(title: String,date: Date, anns: [Annotation]) {
        self.id = UUID().uuidString
        self.title = title
        self.date = date
        self.annotations = anns
    }
    
    
}
