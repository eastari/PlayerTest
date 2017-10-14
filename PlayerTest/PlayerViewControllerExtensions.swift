//
//  PlayerViewControllerExtensions.swift
//  PlayerTest
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

// MARK: - Table view data source
extension PlayerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        
        if let songCell = cell as? SongTableViewCell {
            songCell.song =  items[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath){
        
        playerPresenter?.playSong(indexPath.row)
    }
}

//MARK: - PlayerPresenterOutput
extension PlayerViewController: PlayerPresenterOutput {
    
    func update(withData data: [Songs.Item]) {
        DispatchQueue.main.async {self.items = data}
    }
    
    func updateCurrentSong(_ song: Songs.Item) {
        
        fullPlayerView.songNameLabel.text = song.name
        fullPlayerView.authorNameLabel.text = song.author?.name
        fullPlayerView.coverImage.image = nil
        playButton.image = UIImage(named: "pause")
        songNameLabel.text = song.name
        authorNameLabel.text = song.author?.name
        bottomPlayerView.isHidden = false
        guard let urlStr = song.picture?.large  else {return}
        guard let url = URL(string: urlStr)  else {return}
        
        DispatchQueue.global(qos: .userInitiated).async {
            let contentsOfURL = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                guard let data = contentsOfURL  else {return}
                self.fullPlayerView.coverImage.image = UIImage(data: data)
            }
        }
    }
    
    func updateCurrentTime(duration: Double, currentTime: Double, isPlaying: Bool) {
        // Format seconds for human readable string
        fullPlayerView.durationLabel.text = getMinutesSecondsFrom(seconds: duration)
        fullPlayerView.currentTime.text = getMinutesSecondsFrom(seconds: currentTime)
        
        if isPlaying {
            fullPlayerView.playButton.image = UIImage(named: "pause")
            playButton.image = UIImage(named: "pause")
            bottomPlayerView.isHidden = false
        } else {
            fullPlayerView.playButton.image = UIImage(named: "play")
            playButton.image = UIImage(named: "play")
            bottomPlayerView.isHidden = true
        }
        guard duration > 0 else {return}
        fullPlayerView.playProgressSlider.value = Float(currentTime / duration)
        
    }
    
    func updateWithoutData(error: String) {
        self.showAlert(title: "Error", message: error)
    }
}
