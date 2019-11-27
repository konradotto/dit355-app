//
//  ConversionManager.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-27.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import SwiftyJSON

class ConversionManager {
    
    static let shared = ConversionManager()
    private init(){}
    
    func convertToStruct(_ str: String) -> RequestModel {
        
        let jsonData  = JSON(parseJSON: str)
        let jsonObjet = jsonData["travelRequest"]
        return RequestModel(obj: jsonObjet)
        
    }
    
    
    
 
    
    
    
}
