////
////  TestViewController.swift
////  Sean_Fiverr
////
////  Created by Dana Andrea on 9/3/19.
////  Copyright © 2019 Dana Andrea. All rights reserved.
////
//
////
////  ViewController.swift
////  Sean_Fiverr
////
////  Created by Dana Andrea on 9/3/19.
////  Copyright © 2019 Dana Andrea. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//class ViewController: UIViewController, AVAudioRecorderDelegate {
//
//    var audioRecorder : AVAudioRecorder!
//
//
//    @IBOutlet weak var buttonLabel: UIButton!
//
//    @IBOutlet weak var nameOfRecord: UITextField!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupRecorder()
//
//    }
//
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//
//
//    func setupRecorder() {
//        if nameOfRecord.text != nil {
//
//            let audioFilename = getDocumentsDirectory().appendingPathComponent(String(nameOfRecord.text!))
//            let settings = [ AVFormatIDKey : kAudioFormatAppleLossless,
//                             AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
//                             AVEncoderBitRateKey : 320000,
//                             AVNumberOfChannelsKey : 2,
//                             AVSampleRateKey : 44100.2] as [String : Any]
//
//            do {
//                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings )
//                audioRecorder.delegate = self
//                audioRecorder.prepareToRecord()
//            } catch {
//                // displayAlert(title: "Oops!", message: "RecordingFailed")
//                print(error)
//            }
//        } else {
//
//        }
//
//    }
//
//        func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//
//
//        }
//    
//
//    @IBAction func record(_ sender: UIButton) {
//
//        if buttonLabel.titleLabel?.text == "Record" {
//            audioRecorder.record()
//            buttonLabel.setTitle("Stop", for: .normal)
//        } else {
//            audioRecorder.stop()
//            buttonLabel.setTitle("Record", for: .normal)
//        }
//
//    }
//
//
//}
//
