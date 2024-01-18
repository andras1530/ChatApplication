//
//  SettingsTableViewController.swift
//  chatApplication
//
//  Created by Nagy Andras on 18.01.2024.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    //MARK: -IBOutlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    //MARK: -View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showUserInfo()
    }
    //MARK: TableView Delegates
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
    
    
    
        //MARK: - IBActions
    
    @IBAction func tellAFriendButtonPressed(_ sender: Any) {
        print("tell a friend")
    }
    
    @IBAction func termsAndConditionButtonPressed(_ sender: Any) {
        print("terms an cond")
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        print("logout")
    }
    
    //MARK: - UpdateUI
    private func showUserInfo() {
        if let user = User.currentUser {
            usernameLabel.text = user.username
            statusLabel.text = user.status
            appVersionLabel.text = "App version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            if user.avatarLink != ""{
                //download and set avatar image
            }
            
        }
    }
}
