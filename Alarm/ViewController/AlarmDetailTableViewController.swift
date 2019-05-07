//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Lo Howard on 5/6/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            self.updateViews()
        }
    }
    
    var alarmIsOn: Bool = true

    @IBOutlet weak var datePickerLabel: UIDatePicker!
    @IBOutlet weak var alarmTextField: UITextField!
    @IBOutlet weak var enabledButtonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func enableButtonTapped(_ sender: Any) {
        if let alarm = alarm {
            AlarmController.shared.toggleEnabled(alarm: alarm)
            alarmIsOn = alarm.enabled
        } else {
            alarmIsOn = !alarmIsOn
        }
        alarmButtonOnOff()
}
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = alarmTextField.text else { return }
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireDate: datePickerLabel.date, name: name, enabled: alarmIsOn)
        } else {
            AlarmController.shared.addAlarm(fireDate: datePickerLabel.date, name: name, enabled: alarmIsOn)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func alarmButtonOnOff() {
        if alarmIsOn == true {
            enabledButtonLabel.backgroundColor = .green
            enabledButtonLabel.setTitle("On", for: .normal)
        } else {
            enabledButtonLabel.backgroundColor = .white
            enabledButtonLabel.setTitle("Off", for: .normal)
        }
    }
    
    func updateViews() {
        if let alarm = alarm {
            alarmIsOn = alarm.enabled
            datePickerLabel.date = alarm.fireDate
            alarmTextField.text = alarm.name
            alarmButtonOnOff()
        }
    }
}
