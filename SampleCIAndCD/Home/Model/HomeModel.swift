//
//  HomeModel.swift
//  SampleCIAndCD
//
//  Created by Santhosh Nampally on 24/03/18.
//  Copyright © 2018 Santhosh Nampally. All rights reserved.
//

import UIKit

class HomeModel: NSObject {
    static let sharedHomeModel = HomeModel()
    
    let fetchCount = 30
    
    public func getUsersData(searchStr:String ,sortBy:String , ascendingOrder : Bool,pageNo:Int,fullList:Bool, successCallBack:@escaping (_ dataAry:[UserData]) -> Void) {
        
        let fetchAry:[UserData] = DatabaseHandler.sharedDatabaseHandler.fetchTheDataFromDb(searchStr: searchStr, sortBy: sortBy, ascendingOrder: ascendingOrder, totalCount:((fullList) ? 0 : fetchCount), startingFrom: (pageNo-1)*fetchCount)
        
        if fetchAry.count == 0 && searchStr == "" && pageNo == 1{
        
            ServiceHandler.sharedServiceHandler.downloadData(requestUrl:  URL.init(string:"https://gist.githubusercontent.com/santhosh1993/f6db345a13578c70625594566daf2540/raw/1c6b9d899bd8c825903f31a7dbb4e59a5e407cdd/MOCK_DATA.json")!, dataCallback: { (responseAry, error) in
                
                if error == nil{
                    let success = DatabaseHandler.sharedDatabaseHandler.insertDataInToDb(dataAry: responseAry)
                    if success
                    {
                        successCallBack(DatabaseHandler.sharedDatabaseHandler.fetchTheDataFromDb(searchStr:"", sortBy:"rowId", ascendingOrder: ascendingOrder, totalCount:((fullList) ? 0 : self.fetchCount), startingFrom: (pageNo-1)*self.fetchCount))
                    }
                }
            })
            
        }
        else
        {
            successCallBack(fetchAry)
        }
    }
}
