//
//  DetailView.swift
//  SampleCIAndCD
//
//  Created by Santhosh Nampally on 24/03/18.
//  Copyright © 2018 Santhosh Nampally. All rights reserved.
//

import UIKit
import MapKit

protocol DetailViewDelegate: class {
    func getTheNextDetails()
    func getThePreviousDetails()
}

class DetailView: UIView,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var userGender: UILabel!
    @IBOutlet weak var userDetailsTableVw: UITableView!
    
    weak var delegate:DetailViewDelegate?
    var myAnnotation :MKPointAnnotation = MKPointAnnotation.init()
    
    
    var displayData:UserData?{
        didSet{
            userNameLbl.text = "\((displayData?.firstName)!) \((displayData?.lastName)!)"
            userEmailLbl.text = displayData!.email
            userGender.text = displayData!.gender
            userImageView.sd_setImage(with: URL(string:(displayData?.imageUrl!)!))
            
            updateTheAnnotation()
            updateTheAddress()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCellIdentifier", for: indexPath) as! DetailsTableViewCell
        
        
        cell.detailsLbl.text = displayData?.details
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func updateTheAnnotation(){
        
        mapView.removeAnnotation(myAnnotation)
        myAnnotation.coordinate = CLLocationCoordinate2DMake( CLLocationDegrees(Float((displayData?.latitude!)!)!),CLLocationDegrees(Float( (displayData?.longitude!)!)!));
        mapView.addAnnotation(myAnnotation)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myAnnotation.coordinate, 3500, 3500);
        mapView.setRegion(region, animated: true)
    }
    
    func updateTheAddress(){
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(CLLocation.init(latitude: myAnnotation.coordinate.latitude, longitude: myAnnotation.coordinate.longitude)) { (placemarksArray, error) in
            
            if (placemarksArray?.count)! > 0 {
                
                let placemark = placemarksArray?.first
                let subLocality = placemark!.subLocality ?? ""
                let locality = placemark!.locality ?? ""
                let administravtiveArea = placemark!.administrativeArea ?? ""
                let postalCode = placemark!.postalCode ?? ""
                
                self.userAddress.text = "\(subLocality) \(locality) \(administravtiveArea) \(postalCode)"
            }
        }
    }
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        delegate?.getThePreviousDetails()
    }
    
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        delegate?.getTheNextDetails()
    }
    
    
}
