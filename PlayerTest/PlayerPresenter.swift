//
//  PlayerPresenter.swift
//  PlayerTest
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import AVFoundation

let baseUrlStr = "https://gist.githubusercontent.com/anonymous/fec47e2418986b7bdb630a1772232f7d/raw/5e3e6f4dc0b94906dca8de415c585b01069af3f7/57eb7cc5e4b0bcac9f7581c8.json"

class  PlayerPresenter: PlayerPresenterInput {
    
    weak private var playerView : PlayerPresenterOutput?
    lazy var saveService: SaveServiceInterfase = {return SaveService()}()
    private var player: AVPlayer?
    private var timer: Timer?
    private var currentSong: Songs.Item?
    private var isPlaying = false
    private var songs: [Songs.Item] = []
    
    func attachView(view:PlayerPresenterOutput){playerView = view}
    
    //MARK: - PlayerPresenterInput
    
    func getSongs() {
        
        let baseUrl = URL(string: "\(baseUrlStr)")!
        load(url: baseUrl) { result in
            switch result {
            case .Success(let value):
                do {
                    self.songs = try Songs(json: value).items
                    self.playerView?.update(withData: self.songs)
                } catch let error  {
                    print(error)
                    self.playerView?.updateWithoutData(error: error.localizedDescription)
                }
            case .Failure(let errString):
                self.playerView?.updateWithoutData(error: errString ?? "Ops...")
            }
        }
    }
    
    func playSong(_ index: Int) {
        
        guard songs.count >= index else {return}
        guard currentSong != songs[index] else {
            pause()
            return
        }
        let song = songs[index]
        playSong(song)
    }
    
    func playNext() {
        guard let currentSong = currentSong else {return}
        let next = songs.next(item: currentSong)
        guard let song = next else {return}
        playSong(song)
    }
    
    func playPrevious() {
        
        guard let currentSong = currentSong else {return}
        
        // If current play progress of song is < 3
        // seconds, play previous song, if it's not, play current song
        if getCurrentTime().1 < 3 {
            let prev = songs.prev(item: currentSong)
            guard let song = prev else {return}
            playSong(song)
        } else {
            playSong(currentSong)
        }
    }
    
    func pause() {
        
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying = isPlaying == false ? true : false
        updateCurrentTime()
    }
    
    // MARK: - Private implementation
    
    private func playSong(_ song: Songs.Item) {
        
        timer?.invalidate()
        
        guard let url = URL(string: song.audioLink) else {return}
        let data = saveService.readFile(fileName: url.lastPathComponent)
        
        var playerItem: CachingPlayerItem
        if let data = data {
            playerItem = CachingPlayerItem(data: data, mimeType: "audio/mpeg", fileExtension: "mp3")
        } else {
            playerItem = CachingPlayerItem(url: url)
        }
        
        playerItem.delegate = self
        player = AVPlayer(playerItem: playerItem)
        player?.automaticallyWaitsToMinimizeStalling = false
        player?.play()
        
        playerView?.updateCurrentSong(song)
        currentSong = song
        isPlaying = true
        // Timer needs to update slider and current time
        timer = Timer.schedule(repeatInterval: 1) { _ in self.updateCurrentTime()}
    }
    
    private func updateCurrentTime() {
        let currentTime = getCurrentTime()
        playerView?.updateCurrentTime(duration: currentTime.0, currentTime: currentTime.1, isPlaying: isPlaying)
    }
    
    private func getCurrentTime() -> (Double, Double) {
        
        // Access current item
        guard let currentItem = player?.currentItem else {return (0,0)}
        let duration = currentItem.asset.duration.seconds
        let currentTime = currentItem.currentTime().seconds
        
        return (duration, currentTime)
        
    }
}

//MARK: - CachingPlayerItemDelegate

extension PlayerPresenter: CachingPlayerItemDelegate {
    
    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {

        print("File is downloaded and ready for storing")
     
        DispatchQueue.main.async {
             _ = self.saveService.writeFile(data: data, fileName: playerItem.url.lastPathComponent)
        }
    }
    
    func playerItem(_ playerItem: CachingPlayerItem, didDownloadBytesSoFar bytesDownloaded: Int, outOf bytesExpected: Int) {
        print("\(bytesDownloaded)/\(bytesExpected)")
    }
    
    func playerItemPlaybackStalled(_ playerItem: CachingPlayerItem) {
        print("Not enough data for playback. Probably because of the poor network. Wait a bit and try to play later.")
    }
    
    func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
        print(error)
    }
    
}

