//
//  Author.swift
//  BillScaner
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation

struct Author {
    let name : String
    let picture : Picture?
    
    init?(dictionary: [String: Any]) {
        
        guard let name = dictionary["name"] as? String,
           let picture = dictionary["picture"] as? [String:Any] else {return nil}
        
        self.name = name
        self.picture = Picture(dictionary: picture)

    }

}
