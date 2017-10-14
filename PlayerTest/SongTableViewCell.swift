//
//  SongTableViewCell.swift
//  PlayerTest
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var spinnerAuthor: UIActivityIndicatorView!
    @IBOutlet weak var spinnerCover: UIActivityIndicatorView!
    
    // MARK: - Public API
    var song: Songs.Item? {
        didSet {
            songNameLabel.text = song?.name
            authorNameLabel.text = song?.author?.name
            guard let authorURL = song?.author?.picture?.small,
                  let pictureURL = song?.picture?.small else {return}
            avatarURL = URL(string: authorURL)
            coverURL = URL(string: pictureURL)
        }
    }
    
    // MARK: - Private implementation
    private var avatarURL: URL? {
        didSet {
            avatarImage.image = nil
            updateUI(.avatar)
        }
    }
    
    private var coverURL: URL? {
        didSet {
            coverImage.image = nil
            updateUI(.cover)
        }
    }
    
    private enum Picture {case avatar, cover}

    private func updateUI(_ picture: Picture) {
        var urlPicture: URL?
        switch picture {
        case .avatar: urlPicture = avatarURL
        case .cover: urlPicture = coverURL}
        
        if let url = urlPicture {
            switch picture {
            case .avatar: spinnerAuthor?.startAnimating()
            case .cover: spinnerCover?.startAnimating()}
            
            DispatchQueue.global(qos: .userInitiated).async {
                let contentsOfURL = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if url == urlPicture {
                        if let imageData = contentsOfURL {
                            
                            switch picture {
                            case .avatar: self.avatarImage?.image = UIImage(data: imageData)
                            case .cover: self.coverImage?.image = UIImage(data: imageData)}
                
                        }
                        
                        switch picture {
                        case .avatar: self.spinnerAuthor?.stopAnimating()
                        case .cover: self.spinnerCover?.stopAnimating()}
                    }
                }
            }
        }
    }
}
