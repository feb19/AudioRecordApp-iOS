//
//  ViewController.swift
//  AudioRecordApp
//
//  Created by TakahashiNobuhiro on 2018/06/30.
//  Copyright © 2018 feb19. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var recording = false
    var playing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("recording.m4a")
        return url
    }
    
    @IBAction func recordButtonWasTapped() {
        if !recording {
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try! session.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recording = true
            
            label.text = "Recording..."
            recordButton.setTitle("STOP", for: .normal)
            playButton.isEnabled = false
        } else {
            audioRecorder.stop()
            recording = false
            
            label.text = "Waiting..."
            recordButton.setTitle("RECORD", for: .normal)
            playButton.isEnabled = true
            
        }
    }
    
    @IBAction func playButtonWasTapped() {
        if !playing {
            audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
            audioPlayer.delegate = self
            audioPlayer.play()
            
            playing = true
            
            label.text = "Playing..."
            playButton.setTitle("STOP", for: .normal)
            recordButton.isEnabled = false
            
        } else {
            audioPlayer.stop()
            playing = false
            
            label.text = "Waiting..."
            playButton.setTitle("PLAY", for: .normal)
            recordButton.isEnabled = true
            
        }
    }

}

