//
//  FetchData.swift
//  Travel ID
//
//  Created by Patricia Fiona on 28/07/21.
//

import Foundation
import UIKit

class FetchData{
    
    init(){}
    
    func fetchData(urlForFetchingData: String, completionHandler: @escaping (APIData) -> Void ){
        
        var DataSpace = APIData()
        
        //code for calling web API
        if let urlToServer = URL.init(string: urlForFetchingData){
            let task = URLSession.shared.dataTask(with: urlToServer, completionHandler: { (data, response, error) in
                
                if error != nil || data == nil{
                    print("An error occured while fetching data from API")
                }else{
                    if let responseText = String.init(data: data!, encoding: .utf8){
                        let jsonData = responseText.data(using: .utf8)!
                        DataSpace = try! JSONDecoder().decode(APIData.self, from: jsonData)
                        completionHandler(DataSpace)
                    }
                }
            })
            task.resume()
        }
        completionHandler(DataSpace)
    }
    
    func fetchImage(from urlString: String, completionHandler: @escaping (_ data: Foundation.Data?) -> ()) {
        let session = URLSession.shared
        let url = URL(string: urlString)
            
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
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
