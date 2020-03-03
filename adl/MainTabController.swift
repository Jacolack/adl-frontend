//
//  MainTabController.swift
//  adl
//
//  Created by Jack Sheridan on 3/3/20.
//  Copyright © 2020 Jack Sheridan. All rights reserved.
//

import Foundation
import UIKit

class MainTabController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
         if self.getUserInKeychain() == "" {
            showLoginViewController()
        } else {
                   
        }
    }
    
    private func getUserInKeychain() -> String {
         var userId = ""
           do {
             try userId = KeychainItem(service: "com.jacksheridan.adl", account: "userIdentifier").readItem()
           } catch {
               print("Unable to save userIdentifier to keychain.")
           }
         return userId
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
