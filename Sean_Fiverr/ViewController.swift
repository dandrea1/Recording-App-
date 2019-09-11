
//
//  TestViewController.swift
//  Sean_Fiverr
//
//  Created by Dana Andrea on 9/3/19.
//  Copyright © 2019 Dana Andrea. All rights reserved.
//

//
//  ViewController.swift
//  Sean_Fiverr
//
//  Created by Dana Andrea on 9/3/19.
//  Copyright © 2019 Dana Andrea. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation


class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    //MARK: Variable Setup
    var audioRecorder : AVAudioRecorder!
    
    var recordingStarted : Bool = false
    
    var numberOfRecords : Int = 0
    
    @IBOutlet weak var startRecordingView: UIView!
    
    @IBOutlet weak var startRecording: UIButton!
    
    @IBOutlet weak var recordingNameTextField: UITextField!
    
    @IBOutlet weak var recordingTableView: UITableView!
    
    var recordings : [NSManagedObject] = []
    
    
    //Mark: Load The View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingTableView.tableFooterView = UIView(frame: CGRect.zero) //only show as many cells as needed to keep UI clean
        recordingTableView.reloadData()
        startRecordingView.isHidden = true
        
        //Get Permission For Auido & Print to Console
        AVAudioSession.sharedInstance().requestRecordPermission{ (hasPermission) in
            if hasPermission
            {
                print("ACCEPTED")
            }
        }
        
    }
    
    //MARK: Fetch Existing Recordings From Core Data When App Relaunches
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RecordTable")
        
        do {
            recordings = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: Prepare for Recording
    
    @IBAction func newRecordingPressed(_ sender: UIButton) {
        
        startRecordingView.isHidden = false
    }
    
    //Function that gets path to directory where audio is saved
    func getDirectory() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        return documentDirectory
    }
    
    
    //MARK: Record Audio & Save Audio
    
    @IBAction func startRecordingPressed(_ sender: UIButton) {
        
        
        if recordingStarted == false {
            
            if recordingNameTextField.text == "" {
                //Don't start recording and show alert
                let alert = UIAlertController(title: "Incomplete Name", message: "Please add Recording Name", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true)
                print("Text field blank")
                
            } else {
                numberOfRecords += 1
                //Save Audio Path in File Manager
                let fileName = getDirectory().appendingPathComponent("\(recordingNameTextField.text ?? "recording").m4a")
                let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
                
                //Starting Audio Recording
                do{
                    audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                    audioRecorder.delegate = self
                    audioRecorder.record()
                    
                    startRecording.setTitle("Stop Recording", for: .normal)
                    recordingStarted = true
                    
                }
                catch{
                    let alert = UIAlertController(title: "Oops!", message: "Recording Failed", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true)
                }
            }
            
        } else {
            //Stop the Recording and Save To Table View
            recordingStarted = false
            audioRecorder.stop()
            audioRecorder = nil
            UserDefaults.standard.set(numberOfRecords, forKey: "myNumber")
            insertNewReocrdingTitle() //inserts new record into table
            startRecording.setTitle("Start Recording", for: .normal)
            
            startRecordingView.isHidden = true
        }
    }
    
    //Add New Recording To Table View
    func insertNewReocrdingTitle() {
        
        let recordingNameString = recordingNameTextField.text
        self.save(name: recordingNameString!) //Save to core data
        
        recordingNameTextField.text = ""
        recordingTableView.reloadData() //updates table with newly inserted record
        
    }
    
    //Save New Recording To Core Data
    func save(name: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "RecordTable", in: managedContext)!
        
        let nameEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        
        nameEntity.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            recordings.append(nameEntity)
            
        } catch let error as NSError {
            
            print("could not save. \(error), \(error.userInfo)")
            
        }
    }
    
    
    
    //MARK: Delete Record
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let record = recordings[indexPath.row]
            let stringRecordName = record.value(forKeyPath: "name") as? String
            
            //delete from file manager
            deleteAudioFile("\(stringRecordName!).m4a")
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext : NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            //delete from core data
            managedContext.delete(recordings[indexPath.row] as NSManagedObject)
            //delete fromt table view
            recordings.remove(at: indexPath.row)
            
            recordingTableView.beginUpdates()
            recordingTableView.deleteRows(at: [indexPath], with: .automatic)
            recordingTableView.endUpdates()
            
            
            do{
                //save deletion
                try managedContext.save()
            } catch {
                print("error couldn't save deletion")
            }
        }
    }
    
    func deleteAudioFile(_ string: String) {
        let fileName = getDirectory().appendingPathComponent(string)
        
        do {
            try FileManager.default.removeItem(at: fileName)
            print("items deleted")
        } catch {
            print(error)
        }
    }
    
}

//MARK: Setup Table View
extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let record = recordings[indexPath.row]
        let cell = recordingTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecordTableViewCell
        
        cell?.recordingLabel.font = UIFont.systemFont(ofSize: 40.0)
        cell?.recordingLabel.text = record.value(forKeyPath: "name") as? String //Name of the recording from Core Data
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    //goToPLay View Controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PlayViewController") as? PlayViewController
        
        let record = recordings[indexPath.row]
        let stringRecordName = record.value(forKeyPath: "name") as? String
        
        vc?.label = stringRecordName!
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }

}
