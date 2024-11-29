//
//  APIClient.swift
//  Stock
//
//  Created by Mitali Ahir on 2024-11-25.
//

import Foundation

class APIClient {
    static let shared = APIClient()

    func fetchStocks(forURL sURL: String, completion: @escaping (Data) -> Void) {
        // Define your API headers
        let headers = [
            "x-rapidapi-key": "72c3bf0585msh554dad757b4e8b6p1528d2jsn24a095060f7f",
            "x-rapidapi-host": "ms-finance.p.rapidapi.com"
        ]
        
        // Create the URLRequest
        let request = NSMutableURLRequest(url: NSURL(string: sURL)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        // Create the session and data task
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                if let data = data{
                    completion(data);
                }
            }
        })

        dataTask.resume()
    }
}

