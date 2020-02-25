//
//  StopWatchViewController.swift
//  StopWatchSection3
//
//  Created by Islam on 2/3/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

class StopWatchViewController: UIViewController {
    
    @IBOutlet weak var stopWatchValue: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    var timer = Timer()
    var time: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func runTimer() {
        time += 1
      //  stopWatchValue.text = String(time)
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        stopWatchValue.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    @IBAction func pauseStopWatch() {
        timer.invalidate()
        startBtn.isEnabled = true
    }
    
    @IBAction func startStopWatch() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in self.runTimer()})
        startBtn.isEnabled  = false
    }
    
    @IBAction func stopStopWatch() {
        time = 0
        stopWatchValue.text = "00:00:00"
        timer.invalidate()
        startBtn.isEnabled = true
    }
}
