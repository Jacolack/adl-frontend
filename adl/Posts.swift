//
//  Posts.swift
//  adl
//
//  Created by Jack Sheridan on 3/11/20.
//  Copyright © 2020 Jack Sheridan. All rights reserved.
//

import Foundation
import UIKit

class Posts : UITableViewController {
    private var postsArray = [ADLPost]()
    
    public var theCommID = 0
    public var communityTitle = ""
    
    
    
    @IBAction func createPostAct(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "createPost") as! CreatePost
        vc.theComm = theCommID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        self.tableView.tableFooterView = UIView()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableView.refreshControl = refreshControl
        self.title = communityTitle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    @objc func refresh() {
        ADLRequest.getPosts(communityID: String(theCommID)) { (succ, result) in
            if (succ) {
                self.postsArray = result as! [ADLPost]
                print(self.postsArray)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                }
            } else {
                print("did not decode")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thePost = postsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        cell.titleLbl.text = thePost.Title
        cell.bodyLbl.text = thePost.TextBody
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}

