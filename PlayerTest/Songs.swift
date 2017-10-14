//
//  Songs.swift
//  BillScaner
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation

struct Songs {
    
    struct Item {
        let audioLink: String
        let name: String
        let picture: Picture?
        let author: Author?
        
        enum Error: Swift.Error {
            case emptyAudioLink, emptyName
        }
        
        init(audioLink: String,
             name: String,
             picture: Picture? = nil,
             author: Author? = nil) throws {
            
            guard !audioLink.isEmpty else { throw Error.emptyAudioLink }
            guard !name.isEmpty else { throw Error.emptyName }
            
            self.audioLink = audioLink
            self.name = name
            self.picture = picture
            self.author = author

        }
    }
    
    let items: [Item]
}

extension Songs.Item: Hashable {
    var hashValue: Int {
        return audioLink.hashValue
    }
    
    static func == (lhs: Songs.Item, rhs: Songs.Item) -> Bool {
        return lhs.audioLink == rhs.audioLink && lhs.audioLink == rhs.audioLink
    }
}

extension Songs {
    
    enum JSONParsingError: Error {
        case notObject(Any)
        case notNestedData(Any)
        case itemNotCorrect([String: Any])
    }
    
    init(json load: Data) throws {
        try self.init(json: JSONSerialization.jsonObject(with: load))
    }
    
    init(json jsonObject: Any) throws {

        guard let nestedData = jsonObject as? [String: Any] else {
            throw JSONParsingError.notObject(jsonObject)
        }
        guard let json = nestedData["data"] as? [Any] else {
            throw JSONParsingError.notNestedData(jsonObject)
        }
        
        self.items = try json.map {jsonObject in
            guard let json = jsonObject as? [String: Any] else {
                throw JSONParsingError.notObject(jsonObject)
            }
            guard let audioLink = json["audioLink"] as? String,
                       let name = json["name"] as? String else {
                    throw JSONParsingError.itemNotCorrect(json)
            }
            
            var pictureObj: Picture? = nil; var authorObj: Author? = nil
            
            if let picture = json["picture"] as? [String:Any],
                let author = json["author"] as? [String:Any] {
                
                pictureObj = Picture.init(dictionary: picture)
                authorObj  = Author.init(dictionary: author)
            }
            
            return try Songs.Item(audioLink: audioLink,
                                  name: name,
                                  picture: pictureObj,
                                  author: authorObj)
        }
    }
}

