//
//  AlarmTableViewController.swift
//  Alarm
//
//  Created by Lo Howard on 5/6/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.shared.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell
        let alarm = AlarmController.shared.alarms[indexPath.row]
        cell?.updateViews(alarm: alarm)
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let alarm = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toAlarmVC"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let alarm = AlarmController.shared.alarms[indexPath.row]
            let destinationVC = segue.destination as? AlarmDetailTableViewController
            destinationVC?.alarm = alarm
        }
    }

}

extension AlarmTableViewController: SwitchTableViewCellDelegate {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alarm = AlarmController.shared.alarms[indexPath.row]
        AlarmController.shared.toggleEnabled(alarm: alarm)
        cell.updateViews(alarm: alarm)
    }
}
