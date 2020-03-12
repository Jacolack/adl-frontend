//
//  Home.swift
//  adl
//
//  Created by Jack Sheridan on 3/11/20.
//  Copyright © 2020 Jack Sheridan. All rights reserved.
//

import Foundation
import UIKit

class Home : UITableViewController {
    private var commsArray = [ADLComm]()
    
    override func viewDidLoad() {
        self.tableView.tableFooterView = UIView()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableView.refreshControl = refreshControl
    }

    @objc func refresh() {
        ADLRequest.getComms { (succ, result) in
            if (succ) {
                self.commsArray = result as! [ADLComm]
                print(self.commsArray)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                }
            } else {
                print("did not decode")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theComm = commsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        cell.titleLbl.text = theComm.Name
        cell.descriptionLbl.text = theComm.Description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commsArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = self.storyboard?.instantiateViewController(identifier: "posts") as! Posts
        vc.theCommID = commsArray[indexPath.row].CommunityID
        vc.communityTitle = commsArray[indexPath.row].Name
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
