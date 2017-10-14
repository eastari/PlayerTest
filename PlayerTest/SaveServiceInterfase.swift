//
//  SaveServiceInterfase.swift
//  PlayerTest
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation

protocol SaveServiceInterfase: class {
    
    func writeFile(data:Data, fileName:String) -> Bool
    func readFile(fileName:String) -> Data?
}
