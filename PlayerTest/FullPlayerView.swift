//
//  FullPlayerView.swift
//  PlayerTest
//
//  Created by 2Mac on 14.10.17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class FullPlayerView: UIView {
    
    @IBOutlet weak var playProgressSlider: UISlider!
    @IBOutlet weak var playButton: ImageViewTappable!
    @IBOutlet weak var nextButton: ImageViewTappable!
    @IBOutlet weak var previousButton: ImageViewTappable!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    
    var downTapped: (() -> ())?
    var playPauseTapped: (() -> ())?
    var nextTapped: (() -> ())?
    var previousTapped: (() -> ())?
    
    var view: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.addSubview(view)
        
        playButton.image = UIImage(named: "pause")
        
        playButton.makeTappable(target: self, action: #selector(self.playBtnTapped))
        nextButton.makeTappable(target: self, action: #selector(self.nextBtnTapped))
        previousButton.makeTappable(target: self, action: #selector(self.previousBtnTapped))
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "FullPlayerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    @IBAction func downTapped(_ sender: UIButton) {
        downTapped?()
    }
    
    func playBtnTapped(_ sender: UITapGestureRecognizer) {
        playPauseTapped?()
    }
    
    func nextBtnTapped(_ sender: UITapGestureRecognizer) {
        nextTapped?()
        zeroize()
    }
    
    func previousBtnTapped(_ sender: UITapGestureRecognizer) {
        previousTapped?()
        zeroize()
    }
    
    func zeroize() {
        playProgressSlider.value = 0
        durationLabel.text = ""
        currentTime.text = ""

    }
    
}
