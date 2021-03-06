//
//  CreateComm.swift
//  adl
//
//  Created by Jack Sheridan on 3/11/20.
//  Copyright © 2020 Jack Sheridan. All rights reserved.
//

import Foundation
import UIKit

class CreateComm: UIViewController {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    override func viewDidLoad() {
        
    }
    @IBAction func createAct(_ sender: Any) {
        let newUser = ADLComm(inTitle: nameTF!.text!, inDescription: descriptionField.text, inCreator: Int(ADLRequest.myUserId)!)
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                                
                do {
                    let jsonData = try encoder.encode(newUser)
                let createComm = UIAlertController(title: "Creating Community", message: nil, preferredStyle: .alert)
                self.present(createComm, animated: true, completion: nil)
                ADLRequest.postRequest(givenUrl: "/community/create", object: jsonData, callback: {(succ, resp) in
                    DispatchQueue.main.async {
                    if (succ) {
                        print("created Community")
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
