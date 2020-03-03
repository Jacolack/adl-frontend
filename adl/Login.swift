//
//  Login.swift
//  adl
//
//  Created by Jack Sheridan on 2/11/20.
//  Copyright © 2020 Jack Sheridan. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginProviderStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProviderLoginView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /// - Tag: add_appleid_button
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    // - Tag: perform_appleid_password_request
    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    /// - Tag: perform_appleid_request
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if let lastName = fullName?.familyName {
                if let firstName = fullName?.givenName {
                    if let newEmail = email {
                        let newUser = ADLUser(fName: firstName, lName: lastName, em: newEmail, access: userIdentifier)
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted
                         
                        do {
                            let jsonData = try encoder.encode(newUser)
                            let createUser = UIAlertController(title: "Creating User", message: nil, preferredStyle: .alert)
                            self.present(createUser, animated: true, completion: nil)
                            ADLRequest.postRequest(givenUrl: "users/create", object: jsonData, callback: {(succ, resp) in
                                DispatchQueue.main.async {
                                if (succ) {
                                    print("created user")

                                    self.saveUserInKeychain(String(resp! as! Int))
                                    createUser.dismiss(animated: true) {
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                } else {
                                    print("failed to create user")

                                    createUser.dismiss(animated: true) {
                                        ADLRequest.showError(title: "Error", message: (resp as! String), vc: self)
                                    }
                                }
                            }
                            }
                            )
                        } catch {
                            print("Error encoding object")
                        }
                    }
                }
            } else {
                let signInUser = UIAlertController(title: "Signing In", message: nil, preferredStyle: .alert)
                self.present(signInUser, animated: true, completion: nil)
                ADLRequest.getUserID(token: userIdentifier, callback: {(succ, resp) in
                    DispatchQueue.main.async {
                    if (succ) {
                        self.saveUserInKeychain(String(resp! as! Int))
                            signInUser.dismiss(animated: true) {
                                self.dismiss(animated: true, completion: nil)
                            }
                    } else {
                        signInUser.dismiss(animated: true) {
                            ADLRequest.showError(title: "Error", message: (resp as! String), vc: self)
                        }
                    }
                    }
                })
                
            }
            
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
        
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            ADLRequest.showError(title: "Error", message: "idk", vc: self)

        default:
            break
        }
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.jacksheridan.adl", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
        
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        ADLRequest.showError(title: "Error", message: error.localizedDescription, vc: self)
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
