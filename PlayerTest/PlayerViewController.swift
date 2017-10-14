//
//  PlayerViewController.swift
//  PlayerTest
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController, Alertable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomPlayerView: ViewTappable!
    @IBOutlet weak var fullPlayerView: FullPlayerView!
    @IBOutlet weak var topConstraintFullPlayer: NSLayoutConstraint!
    @IBOutlet weak var playButton: ImageViewTappable!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    var items: [Songs.Item] = [] {didSet {tableView.reloadData()}}
    
    var playerPresenter: PlayerPresenterInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assembly module
        let presenter = PlayerPresenter()
        presenter.attachView(view: self)
        self.playerPresenter = presenter
        
        // Get songs from web
        playerPresenter?.getSongs()
        
        // Make view tappable
        bottomPlayerView.makeTappable(target: self, action: #selector(self.bottomPlayerTapped))
        playButton.makeTappable(target: self, action: #selector(self.playButtonTapped))
        
        // Bind with fullPlayerView
        fullPlayerView.downTapped = { [weak self] in
            self?.showHideFullPlayerView(isShow: false)
        }
        fullPlayerView.playPauseTapped = { [weak self] in
            self?.playerPresenter?.pause()
        }
        fullPlayerView.nextTapped = { [weak self] in
            self?.playerPresenter?.playNext()
        }
        fullPlayerView.previousTapped = { [weak self] in
            self?.playerPresenter?.playPrevious()
        }
        
    }
    // Animations
    private func showHideFullPlayerView(isShow: Bool) {
        self.navigationController?.navigationBar.isHidden = isShow
        topConstraintFullPlayer.constant = isShow ? 0 : view.frame.height
        UIView.animate(withDuration: 0.7, animations: {
            self.view.layoutIfNeeded()
        }) { _ in }
    }
    
    //MARK: - Actions

    func bottomPlayerTapped(_ sender: UITapGestureRecognizer) {
        showHideFullPlayerView(isShow: true)
    }
    
    func playButtonTapped(_ sender: UITapGestureRecognizer) {
        playerPresenter?.pause()
    }
}
