//
//  ServiceHandler.swift
//  SampleCIAndCD
//
//  Created by Santhosh Nampally on 24/03/18.
//  Copyright © 2018 Santhosh Nampally. All rights reserved.
//

import UIKit

class ServiceHandler: NSObject {
    
    static let sharedServiceHandler = ServiceHandler()
    
    
    public func downloadData(requestUrl: URL , dataCallback:@escaping (_ response:[[String : Any]], _ error:Error?) -> Void)
    {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession.init(configuration: configuration)
        
        let task:URLSessionDataTask = session.dataTask(with: requestUrl) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if(error == nil)
            {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String : Any]]
                    dataCallback(parsedData,error)
                }
                catch let error as NSError
                {
                    // Call backs when ever the error posts while parsing the data
                    dataCallback([],error)
                }
            }
            else
            {
                // Call back calls when ever the error posts while fetching the data
                dataCallback([],error)
            }
            
        }
        
        task.resume()
    }

}
