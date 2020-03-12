//
//  CreatePost.swift
//  adl
//
//  Created by Jack Sheridan on 3/11/20.
//  Copyright © 2020 Jack Sheridan. All rights reserved.
//


import Foundation
import UIKit

class CreatePost: UIViewController {
    
    public var theComm = 0
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var bodyTF: UITextField!
    override func viewDidLoad() {
        
    }
    @IBAction func createAct(_ sender: Any) {
        
        let newPost = ADLPost(inCommID: theComm, inTitle:  nameTF!.text!, inBody: bodyTF.text!, inCreator: Int(ADLRequest.myUserId)!)
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                                
                do {
                    let jsonData = try encoder.encode(newPost)
                let createComm = UIAlertController(title: "Creating Post", message: nil, preferredStyle: .alert)
                self.present(createComm, animated: true, completion: nil)
                ADLRequest.postRequest(givenUrl: "/post/create", object: jsonData, callback: {(succ, resp) in
                    DispatchQueue.main.async {
                    if (succ) {
                        print("created post")
                        createComm.dismiss(animated: true) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                    print(resp!)
                    createComm.dismiss(animated: true) {
                        ADLRequest.showError(title: "Error", message: (resp as! String), vc: self)
                    }
                }
            }
        })
        } catch {
        print("Error encoding object")
        }
    }
}
