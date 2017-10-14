//
//  SaveService.swift
//  PlayerTest
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation

class SaveService: NSObject, SaveServiceInterfase {
    
    func writeFile(data:Data, fileName:String) -> Bool {
        
        let fileURL: URL
        do {
            fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(fileName)")
        } catch let error {
            print(error); return false
        }
        
        do {
            try data.write(to: fileURL, options: .atomic)
        } catch let error {
            print(error); return false
        }
        
        return true
    }
    
    func readFile(fileName:String) -> Data? {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let path = documentsURL?.appendingPathComponent("\(fileName)").path
        
        guard let filePath = path else {return nil}
        
        if FileManager.default.fileExists(atPath: filePath) {

            do {
                let url:URL = URL.init(fileURLWithPath: filePath)
                let data = try Data(contentsOf: url)
                return data
            } catch let error {
                print(error)
                return nil
                
            }
        }
        return nil
    }
}
