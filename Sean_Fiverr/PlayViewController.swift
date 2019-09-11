//
//  PlayViewController.swift
//  Sean_Fiverr
//
//  Created by Dana Andrea on 9/10/19.
//  Copyright © 2019 Dana Andrea. All rights reserved.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var recordingTitleLabel: UILabel!
    
    var label = ""
    
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingTitleLabel.text = "\(label)"

        // Do any additional setup after loading the view.
    }

    //MARK: Play Contents
    @IBAction func playPressed(_ sender: UIButton) {
        stopAudioPlayer()
        
        let contents = label
        
        let audioFilename = getDirectory().appendingPathComponent("\(contents).m4a")
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
                    print(audioFilename)
                    audioPlayer.delegate = self
                    audioPlayer.prepareToPlay()
                    audioPlayer.volume = 3.0
                } catch {
                    print(error)
                }
        
                startAudioPlayer()
    }
    
    
    //MARK: Prepare for Playing
    
    func stopAudioPlayer() {
        if audioPlayer != nil {
            audioPlayer.stop()
        }
    }
    
    func startAudioPlayer() {
        if audioPlayer != nil {
            audioPlayer.play()
        }
        
    }
    
    //Function that gets path to directory where audio is saved
    func getDirectory() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        return documentDirectory
    }
}

