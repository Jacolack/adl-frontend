//
//  Profile.swift
//  adl
//
//  Created by Winnie Wang on 3/5/20.
//  Copyright © 2020 Jack Sheridan. All rights reserved.
//

import Foundation
import UIKit

class Profile : UIViewController {
    
    @IBAction func logOutAct(_ sender: Any) {
        logOut()
    }
    
    private func logOut() {
        do {
            try KeychainItem(service: "com.jacksheridan.adl", account: "userIdentifier").saveItem("")
            showLoginViewController()
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController {
            loginViewController.modalPresentationStyle = .fullScreen
            loginViewController.isModalInPresentation = true
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
}
