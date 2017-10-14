//
//  Functions.swift
//  PlayerTest
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation

enum Result<T> {
    case Success(T)
    case Failure(String?)
}

func load(url: URL, completion: @escaping (Result<Data>) -> Void)  {
    URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
        let result: Result<Data>
        if let data = data {
            result = Result.Success(data)
        } else if let  response = response {
            result = Result.Failure(response.debugDescription)
        } else {
            result = Result.Failure(error?.localizedDescription)
        }
        completion(result)
    }) .resume()
}

func getMinutesSecondsFrom(seconds: Double) -> String {
    
    func timeText(_ number: Int) -> String {
        return number < 10 ? "0\(number)" : "\(number)"
    }
    
    let secs = Int(seconds)
    let minutes = (secs % 3600) / 60
    let seconds = (secs % 3600) % 60
    
    return "\(timeText(minutes)):\(timeText(seconds))"
    
}

