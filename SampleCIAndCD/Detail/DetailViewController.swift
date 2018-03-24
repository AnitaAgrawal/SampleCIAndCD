//
//  DetailViewController.swift
//  SampleCIAndCD
//
//  Created by Santhosh Nampally on 24/03/18.
//  Copyright © 2018 Santhosh Nampally. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,DetailViewDelegate {

    
    @IBOutlet var detailVw: DetailView!
    var displayData : UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailVw.displayData = displayData
        detailVw.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func mapViewBtnTapped(_ sender: UIButton) {
        
        let destinationController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as! HomeViewController
        
        destinationController.showTheUserDetailsInMapView(userDetails: displayData!)
        
        _ = self.navigationController?.popViewController(animated: true)

    }
    
    
    //MARK: - Detail View Delegate
    
    func getTheNextDetails() {
        updateTheView(updatedData:DatabaseHandler.sharedDatabaseHandler.fetchTheDataFromDb(rowId: Int((displayData?.rowId)!+1)))
    }
    
    func getThePreviousDetails() {
        if ((displayData?.rowId)!-1) != 0{
        updateTheView(updatedData: DatabaseHandler.sharedDatabaseHandler.fetchTheDataFromDb(rowId: Int((displayData?.rowId)!-1)))
        }
    }
    
    func updateTheView(updatedData:UserData){
        if updatedData.latitude != "" {
            displayData = updatedData
            detailVw.displayData = displayData
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
