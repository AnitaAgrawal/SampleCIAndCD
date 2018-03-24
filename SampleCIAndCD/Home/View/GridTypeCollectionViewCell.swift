//
//  GridTypeCollectionViewCell.swift
//  SampleCIAndCD
//
//  Created by Santhosh Nampally on 24/03/18.
//  Copyright © 2018 Santhosh Nampally. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class GridTypeCollectionViewCell: UICollectionViewCell,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userImgVw: UIImageView!
    
    @IBOutlet weak var firstNameLlb: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    var myAnnotation :MKPointAnnotation = MKPointAnnotation.init()
    
    var userDetails:UserData!{
        didSet{
            detailLbl.text = userDetails.details
            firstNameLlb.text = userDetails.firstName
            userImgVw.sd_setImage(with: URL(string:userDetails.imageUrl!))
            updateTheAnnotation()
        }
    }
    
    override func awakeFromNib() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: -0.2, height: 0.2)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    
    func updateTheAnnotation(){
        
        mapView.removeAnnotation(myAnnotation)
        myAnnotation.coordinate = CLLocationCoordinate2DMake( CLLocationDegrees(Float(userDetails.latitude!)!),CLLocationDegrees(Float( userDetails.longitude!)!));
        mapView.addAnnotation(myAnnotation)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myAnnotation.coordinate, 3500, 3500);
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Map View Delegate
    
    
    
}
