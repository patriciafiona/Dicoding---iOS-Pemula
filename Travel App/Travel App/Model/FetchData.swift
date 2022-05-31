//
//  FetchData.swift
//  Travel ID
//
//  Created by Patricia Fiona on 28/07/21.
//

import UIKit

class FetchData{
    
    init(){}
    
    func fetchData(urlForFetchingData: String, completionHandler: @escaping (APIData) -> Void ){
        
        var dataSpace = APIData()
        
        //code for calling web API
        if let urlToServer = URL.init(string: urlForFetchingData){
            let task = URLSession.shared.dataTask(with: urlToServer, completionHandler: { (data, response, error) in
                
                if error != nil || data == nil{
                    print("An error occured while fetching data from API")
                } else {
                    if let responseText = String.init(data: data!, encoding: .utf8){
                        let jsonData = responseText.data(using: .utf8)!
                        dataSpace = try! JSONDecoder().decode(APIData.self, from: jsonData)
                        completionHandler(dataSpace)
                    }
                }
            })
            task.resume()
        }
        completionHandler(dataSpace)
    }
    
    func fetchImage(from urlString: String, completionHandler: @escaping (_ data: Foundation.Data?) -> Void) {
        let session = URLSession.shared
        let url = URL(string: urlString)
            
        let dataTask = session.dataTask(with: url!) { (data, _, error) in
            if error != nil {
                print("Error fetching the image! 😢")
                completionHandler(nil)
            } else {
                completionHandler(data)
            }
        }
            
        dataTask.resume()
    }
    
}
