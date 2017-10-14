//
//  PlayerPresenterProtocols.swift
//  PlayerTest
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation

protocol PlayerPresenterInput: class {
    func getSongs()
    func playSong(_ index: Int)
    func playNext()
    func playPrevious()
    func pause()
}

protocol PlayerPresenterOutput: class {
    func update(withData data: [Songs.Item])
    func updateCurrentSong(_ song: Songs.Item)
    func updateCurrentTime(duration: Double, currentTime: Double, isPlaying: Bool)
    func updateWithoutData(error: String)
}
