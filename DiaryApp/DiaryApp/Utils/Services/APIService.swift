//
//  APIService.swift
//  DiaryApp
//
//  Created by Dhara Patel on 08/12/20.
//  Copyright © 2020 Dhara Patel. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    
    func fetchData(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        let request = AF.request(WSURL.diaryList).validate()
        
        request.responseJSON { (response) in
            if let data = response.data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String: AnyObject]] {
                        DispatchQueue.main.async {
                            completion(.Success(json))
                        }
                    }
                } catch _ {
                    return completion(.Error(response.error?.localizedDescription ?? ""))
                }
            }
            
        }
        
       }
}

enum Result <T>{
    case Success(T)
    case Error(String)
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
