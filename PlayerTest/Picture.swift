//
//  Picture.swift
//  BillScaner
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation

struct Picture {
    
    let small : String
    let mid : String
    let large : String
    let xs : String
    let url : String
    

    init?(dictionary: [String: Any]) {
        
        guard let s = dictionary["s"] as? String,
              let m = dictionary["m"] as? String,
              let l = dictionary["l"] as? String,
             let xs = dictionary["xs"] as? String,
            let url = dictionary["url"] as? String else {return nil}
        
        self.small = s
        self.mid = m
        self.large = l
        self.xs = xs
        self.url = url
    }
}
