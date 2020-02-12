//
//  JSONUtils.swift
//  adl
//
//  Created by Jack Sheridan on 2/11/20.
//  Copyright © 2020 Jack Sheridan. All rights reserved.
//

import Foundation

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



class ADLRequest {
    static func getUserID(token: String) {
        print(token)
    }
    
    
    static func postRequest(url: String, object: Data) -> String {
        
        print(url)
        //print(String(data: object, encoding: String.Encoding.utf8))
        
               // create post request
       let url = URL(string: "http://httpbin.org/post")!
       var request = URLRequest(url: url)
       request.httpMethod = "POST"

       // insert json data to the request
       request.httpBody = object

       let task = URLSession.shared.dataTask(with: request) { data, response, error in
           guard let data = data, error == nil else {
               print(error?.localizedDescription ?? "No data")
               return
           }
           let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
           if let responseJSON = responseJSON as? [String: Any] {
               print(responseJSON)
           }
       }

       task.resume()
        return "succ"
    }
}

