//
//  ViewController.swift
//  LearningRealtimeDB
//
//  Created by Henry Dinhofer on 3/11/17.
//  Copyright © 2017 Henry Dinhofer. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var priceTextView: UITextView!
    @IBOutlet weak var timestampTableView: UITableView!
    
    var timestamps = [TimeStamp]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTextView.delegate = self
        timestampTableView.delegate = self
        timestampTableView.dataSource = self
        
        observePrice()
        observeTimestamps()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func observePrice() {
        let priceRef = FIRDatabase.database().reference().child("price")
        
        let callback = priceRef.observe(.value, with: { (snapshot: FIRDataSnapshot) in
            // ...
            if let price = snapshot.value as? NSNumber {
                // price changed
                self.priceTextView.text = "\(price)"
                
                print("price is now \(price)")
                // add the timestamp to a list of timestamps
                //     then we'll make timestamp happen on a 'bump'
                
                
                
                // cool animation to change price label
                
                
                
            } else {
                print("Unable to capture changed value from db")
            }
            
            
        })
    
    
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let priceRef = FIRDatabase.database().reference().child("price")
        
        
        if let price = Float(textView.text) {
            let priceNSNumber = NSNumber(value: price)
            
            priceRef.setValue(priceNSNumber)
        } else {
            print("Unable to set value on db")
        }
        
        
    }
    @IBAction func doneTapped(_ sender: Any) {
        if self.priceTextView.isFirstResponder {
            self.priceTextView.resignFirstResponder()
        }
    }
    
    
    func observeTimestamps() {
        let timestampsRef = FIRDatabase.database().reference().child("timestamps")
        
        timestampsRef.observe(.value, with: { (snapshot) in
            
            // ... probs should do some null handling
            
            for timestamp in snapshot.children {
                
//                if let autoID = timestamp.value.keys as? String {
//                    print("\(autoID)")
//                }
                print("timestamp is \(timestamp)")
                //print("timestamp value is \((timestamp as AnyObject).value)")
                
                if let timestampsCast = timestamp as? [String: [String: AnyObject]] {
                    print("iflet works! \(timestampsCast)")
                    
                }
                
                if let timestampCastAsArray = timestamp as? NSArray {
                    print("Casting as array worked!! \(timestampCastAsArray)")
                    
                    
                }
                
//                if let timestampCast = timestamp as? [String: AnyObject] {
//                    print("iflet works! \(timestampCast)")
//                }
            }
            
            if let timestamps = snapshot.value as? [String : AnyObject] {
                
//                for (autoid, timestamp) in (timestamps as? [String: [String: AnyObject]])! {
//                    print("1autoid: \(autoid),  timestamp: \(timestamp)") // out of order :( treats it like a dictionary
//                }
                
            }
            
            
            
            // if snapshot.childrenCount > 0 {   continue below V
//            for timestamp in snapshot.children.allObjects as! [FIRDataSnapshot] {
//                print("timestamp.value is \(timestamp.value)")  // actual timestamp object (without key)
//                if let cast = timestamp.value as? [String: AnyObject] {
//                    print("cast is \(cast)")  // yes!!
//                
//                }
//            }
            
            self.timestamps.removeAll() // self inside closure
            let enumerator = snapshot.children
            while let snap = enumerator.nextObject() as? FIRDataSnapshot {
                
                if let timeDictionary = snap.value as? NSDictionary {
                    
                    let obj = TimeStamp(dictionary: timeDictionary)
                    
                    self.timestamps.insert(obj, at: 0)  // self inside closure
                }
                
                //print("whilelooop value \(snap.value)")  // also works
                
            }
            print("Most recent timestamp \(self.timestamps[0].toDate())") // self inside closure
            self.timestampTableView.reloadData()  // self inside closure

             
            
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timestamps.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = timestampTableView.dequeueReusableCell(withIdentifier: "timestampCell", for: indexPath)
        
        let currentTimestamp = timestamps[indexPath.row]
        cell.textLabel?.text = currentTimestamp.user
        cell.detailTextLabel?.text = currentTimestamp.dateString()
        
    
        return cell
    }
    
    @IBAction func timestampTapped(_ sender: Any) {
        
        let timestampsRef = FIRDatabase.database().reference().child("timestamps")
        let currentTime = Date().timeIntervalSince1970
        let newChild = timestampsRef.childByAutoId()
        
        let timeStamp = ["timestamp" : currentTime,
                         "user" : "hdinhofer"] as [String : Any]
        
        newChild.setValue(timeStamp)
        
        
    }
    
}

