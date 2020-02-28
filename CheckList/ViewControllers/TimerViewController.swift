//
//  TimerViewController.swift
//  StopWatchSection3
//
//  Created by Islam on 2/3/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timerValueLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    //var timerInterval: Double = 0.0
    var timer = Timer()
    var time: Int = 0
    var timePickerValueSec: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        timePicker.addTarget(self, action: #selector(datePickerChanged(paramDatePicker:)), for: .valueChanged)
        time = 60
        timerValueLabel.text = convToSec()
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    @objc func datePickerChanged(paramDatePicker: UIDatePicker) {
        print(timePicker.date)
        let calendar = Calendar.current
        if paramDatePicker.isEqual(self.timePicker){
            let hour = calendar.component(.hour, from: paramDatePicker.date) * 3600
            let minute = calendar.component(.minute, from: paramDatePicker.date) * 60
            timePickerValueSec = hour + minute
            time = timePickerValueSec
            timerValueLabel.text = convToSec()
        }
        if (Int(timePicker.countDownDuration) == (timePicker.minuteInterval * 60))
               {
                  // sender.setDate(minDate, animated: true)
                   timePicker.countDownDuration = TimeInterval(60)
               }
    }
    func runTimer(){
        if time <= 0 {
            timer.invalidate()
        }else{
            time -= 1
            timerValueLabel.text = convToSec()
            
        }
    }
    
    @IBAction func startBtnAct() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in self.runTimer()})
        startBtn.isEnabled = false
        timePicker.isEnabled = false
    }
    @IBAction func pauseBtnAct() {
        timer.invalidate()
        startBtn.isEnabled = true
    }
    
    @IBAction func stopBtnAct() {
        time = timePickerValueSec
        timerValueLabel.text = convToSec()
        timer.invalidate()
        startBtn.isEnabled = true
        timePicker.isEnabled = true
    }
    func convToSec() -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
}

//extension TimerViewController: UITextFieldDelegate {
//
//   //Add this function to prevent keyboard editing
//   func textField(_ textField: UITextField,
//           shouldChangeCharactersIn range: NSRange,
//           replacementString string: String) -> Bool {
//       return false
//  }
//
//  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//    if textField === timerValueLabel {
//      //Set the time interval of the date picker after a short delay
//      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//        self.timePicker.countDownDuration = TimeInterval(self.time) ?? 60
//      }
//
//    }
//    return true
//  }
//}
