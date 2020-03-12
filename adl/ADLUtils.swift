//
//  JSONUtils.swift
//  adl
//
//  Created by Jack Sheridan on 2/11/20.
//  Copyright © 2020 Jack Sheridan. All rights reserved.
//

import Foundation
import UIKit

class ADLUser: Codable {
    var userID: Int
    var firstname: String
    var lastname: String
    var email: String
    var biography: String
    var image: String
    var accesstoken: String
    
    init(fName: String, lName: String, em: String, access: String) {
        firstname = fName
        lastname = lName
        email = em
        biography = ""
        accesstoken = access
        userID = 0
        image = ""
    }
    
}

class ADLPost: Codable {
    var PostID: Int
    var Title: String
    var `Type`: String
    var TextBody: String
    var Image: String
    var PosterID: Int
    var CommunityID: Int
    var Active: Int
    var CreatedDate: String
    var ModifiedDate: String


    init(inCommID: Int, inTitle: String, inBody: String, inCreator: Int) {
        PostID = 0
        CommunityID = inCommID
        Title = inTitle
        TextBody = inBody
        `Type` = "TEXT"
        PosterID = inCreator
        Image = ""
        Active = 0
        CreatedDate = ""
        ModifiedDate = ""
    }
}



class ADLComm: Codable {
    var CommunityID: Int
    var Name: String
    var Description: String
    var OwnerID: Int
    var Image: String
    var Active: Int
    var CreatedDate: String
    var ModifiedDate: String

    init(inTitle: String, inDescription: String, inCreator: Int) {
        CommunityID = 0
        Name = inTitle
        Description = inDescription
        OwnerID = inCreator
        Image = ""
        Active = 0
        CreatedDate = ""
        ModifiedDate = ""
    }
}


class ADLRequest {
    public static var myUserId = ""
    private static let rootUrl = "http://23.92.26.42"
    static func getUserID(token: String, callback: @escaping (_: Bool, _: Any?)->Void) {
        print(token)
        
        let url = URL(string: rootUrl + "/users/login?accesstoken=" + token)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // insert json data to the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                callback(false, error?.localizedDescription ?? "No data")
                return
            }
            print(String(data: data, encoding: String.Encoding.utf8)!)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                callback(true, responseJSON["UserID"])
            } else {
                callback(false, String(data: data, encoding: String.Encoding.utf8)!)
            }
        }
        task.resume()
    }
    
    
    static func getComms(callback: @escaping (_: Bool, _: Any?)->Void) {
        
        let url = URL(string: rootUrl + "/community/getforuser?userID=" + myUserId)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // insert json data to the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                callback(false, error?.localizedDescription ?? "No data")
                return
            }
            let jsonDecoder = JSONDecoder()
            
            print(String(data: data, encoding: String.Encoding.utf8)!)
            do {
                let commArray = try jsonDecoder.decode([ADLComm].self, from: data)
                callback(true, commArray)
            } catch {
                print(error)
                callback(false, String(data: data, encoding: String.Encoding.utf8)!)
            }
        }
        task.resume()
    }
    
    
    static func getPosts(communityID: String, callback: @escaping (_: Bool, _: Any?)->Void) {
        
        let url = URL(string: rootUrl + "/post/getforcommunity?communityID=" + communityID)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // insert json data to the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                callback(false, error?.localizedDescription ?? "No data")
                return
            }
            let jsonDecoder = JSONDecoder()
            
            print(String(data: data, encoding: String.Encoding.utf8)!)
            do {
                let commArray = try jsonDecoder.decode([ADLPost].self, from: data)
                callback(true, commArray)
            } catch {
                print(error)
                callback(false, String(data: data, encoding: String.Encoding.utf8)!)
            }
        }
        task.resume()
    }
    
    static func postRequest(givenUrl: String, object: Data, callback: @escaping (_: Bool, _: Any?)->Void) {
        
        //print(String(data: object, encoding: String.Encoding.utf8))
        
               // create post request
        print("Posting: ", givenUrl, " with data: \n", String(data: object, encoding: String.Encoding.utf8)!)

       let url = URL(string: rootUrl + givenUrl)!
       var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       request.httpMethod = "POST"

       // insert json data to the request
        request.httpBody = object

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
           guard let data = data, error == nil else {
               print(error?.localizedDescription ?? "No data")
                callback(false, error?.localizedDescription ?? "No data")
               return
           }
            
           let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
           if let responseJSON = responseJSON as? [String: Any] {
            print(responseJSON)
            callback(true, (responseJSON["insertId"]))
           } else {
            callback(false, String(data: data, encoding: String.Encoding.utf8)!)
            }
       }

       task.resume()
    }
    
    static func showError(title: String?, message: String?, vc: UIViewController) {
        let errorMsg = UIAlertController(title: title, message: message, preferredStyle: .alert)
        errorMsg.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        vc.present(errorMsg, animated: true, completion: nil)
    }
    
}

