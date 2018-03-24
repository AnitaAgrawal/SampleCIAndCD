//
//  HomeViewController.swift
//  SampleCIAndCD
//
//  Created by Santhosh Nampally on 24/03/18.
//  Copyright © 2018 Santhosh Nampally. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,HomeViewDelegate {

    @IBOutlet var homeVw: HomeView!
    
    var pageNo = 1
    var listArray: [UserData] = []
    var searchStr = ""
    var sortBy = "rowId"
    var ascendingOrder = true
    var fullList = false
    
    var selectedData : UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeVw.delegate = self
        homeVw.showLoaderView(show: true)
        getTheDataFromDb()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MAR: - Developer Methods
    
    func getTheDataFromDb(){
        HomeModel.sharedHomeModel.getUsersData(searchStr: searchStr, sortBy: sortBy, ascendingOrder: ascendingOrder, pageNo: pageNo, fullList:fullList) { (dataArray) in
            self.listArray.append(contentsOf: dataArray)
            DispatchQueue.main.async {
                () -> Void in
                self.homeVw.listArray = self.listArray
                self.homeVw.showLoaderView(show: false)
            }
        }
    }
    
    // MARK: - Home View Delegate
    
    func getTheNextPageData() {
        fullList = false
        pageNo = Int(Float(listArray.count)/Float(HomeModel.sharedHomeModel.fetchCount)) + 1
        getTheDataFromDb()
    }
    
    func goToTheDetailView(displayData: UserData) {
        selectedData = displayData
        self.performSegue(withIdentifier: "ToDetailView", sender: self)
    }
    
    func mapViewTapped() {
        fullList = true
        listArray = []
        getTheDataFromDb()
    }
    
    func listViewTapped() {
        fullList = false
        pageNo = 1
        listArray = []
        getTheDataFromDb()
    }
    
    func searchStringUpdated(searchStr: String) {
        fullList = false
        pageNo = 1
        listArray = []
        self.searchStr = searchStr
        getTheDataFromDb()
    }
    
    
    func showTheUserDetailsInMapView(userDetails : UserData){
        homeVw.zoomTheMapToTheUser(userDetails: userDetails)
        homeVw.mapBtnTapped(UIButton())
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ToDetailView" {
            let detailviewController : DetailViewController = segue.destination as! DetailViewController
            
            detailviewController.displayData = selectedData
        }
        
        
        
    }

}
