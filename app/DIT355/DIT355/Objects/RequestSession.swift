//
//  RequestSession.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-14.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation


class RequestSession: NSObject {
    
    
    var name : Date
    var annotations: [Annotation]
    
    
    override public init() {
        name = Date()
        annotations = [Annotation]()
    }
    
    public init(name: Date, anns: [Annotation]) {
        self.name = name
        self.annotations = anns
    }
    
    
}
