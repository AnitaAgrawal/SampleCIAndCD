//
//  HomeView.swift
//  SampleCIAndCD
//
//  Created by Santhosh Nampally on 24/03/18.
//  Copyright © 2018 Santhosh Nampally. All rights reserved.
//

import UIKit
import MapKit

enum LayoutType {
    case list
    case grid
    case map
}

protocol HomeViewDelegate :class {
    func getTheNextPageData()->Void
    func goToTheDetailView(displayData:UserData)->Void
    func mapViewTapped() -> Void
    func listViewTapped() -> Void
    func searchStringUpdated(searchStr:String) -> Void
}


class HomeView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MKMapViewDelegate,UISearchBarDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var gridLayoutBtn: UIButton!
    @IBOutlet weak var listLayoutbtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    
    @IBOutlet weak var listCollectionVw: UICollectionView!
    
    @IBOutlet weak var listCollectionVwBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loaderContainerView: UIView!
    
    @IBOutlet weak var userBreifVw: userBriefView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewTraillingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var selectionAnnotationViewBottomConstraint: NSLayoutConstraint!
    
    var searchedStr : String = ""{
        didSet{
            delegate?.searchStringUpdated(searchStr: searchedStr)
        }
    }
    
    var selectedAnnotationVw : MKPinAnnotationView?
    var selectedLayoutType = LayoutType.list
    weak var delegate:HomeViewDelegate?
    var listArray:[UserData] = []{
        didSet{
            if (selectedLayoutType == LayoutType.map){
                updateTheAnnotations()
            }
            else{
                listCollectionVw.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        gridLayoutBtn.alpha = 0.7
        updateTheViewForNavBar(selectedState: selectedLayoutType)
        showTheMapView(show: false)
        
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillShow(notification:)),
                           name: .UIKeyboardWillShow,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(notification:)),
                           name: .UIKeyboardWillHide,
                           object: nil)

        
    }

    // MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (selectedLayoutType == LayoutType.map) ? 0 : listArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if selectedLayoutType == LayoutType.list {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 120)
        }
        else
        {
            return CGSize(width: UIScreen.main.bounds.size.width-25, height: 120+128)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        if indexPath.row == listArray.count - 3{
            delegate?.getTheNextPageData()
        }
        
        if selectedLayoutType == LayoutType.list {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListTypeCollectionViewCellIdentifier", for: indexPath) as! ListTypeCollectionViewCell
            cell.userDetails = listArray[indexPath.row]
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridTypeCollectionViewCellIdentifier", for: indexPath) as! GridTypeCollectionViewCell
            cell.userDetails = listArray[indexPath.row]
            
            return cell

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.goToTheDetailView(displayData: listArray[indexPath.row])
    }
    
    
    // MARK: - Map View 
    
    func updateTheAnnotations(){
        mapView.removeAnnotations(mapView.annotations)
        
        for userDetails in listArray  {
            let userAnnotation :Annotation = Annotation.init()
            
            userAnnotation.coordinate = CLLocationCoordinate2DMake( CLLocationDegrees(Float(userDetails.latitude!)!),CLLocationDegrees(Float( userDetails.longitude!)!))
            
            userAnnotation.annotationId = Int(userDetails.rowId)
            mapView.addAnnotation(userAnnotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedAnnotation:Annotation = view.annotation as! Annotation
        let filterAry = listArray.filter{Int($0.rowId) == selectedAnnotation.annotationId}
        if (filterAry.count > 0)
        {
            zoomTheMapToTheUser(userDetails:filterAry.last!)
        }
        let pinAnnotationView :MKPinAnnotationView = view as! MKPinAnnotationView
        pinAnnotationView.pinTintColor = MKPinAnnotationView.greenPinColor()
        
        selectedAnnotationVw?.pinTintColor = MKPinAnnotationView.redPinColor()
        selectedAnnotationVw = pinAnnotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
       // showTheUserBriefView(show: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinAnnotationView :MKPinAnnotationView = MKPinAnnotationView()

        if userBreifVw.userDetails != nil{
            if Int(userBreifVw.userDetails.rowId) == (annotation as! Annotation).annotationId{
                selectedAnnotationVw = pinAnnotationView
                pinAnnotationView.pinTintColor = MKPinAnnotationView.greenPinColor()
            }
        }
        else{
            pinAnnotationView.pinTintColor = MKPinAnnotationView.redPinColor()
        }
        
        return pinAnnotationView
    }
    
    // MARK: - call backs
    
    @IBAction func moveTheMapToTheSelectedLocation(_ sender: UIButton) {
        let coordinate = CLLocationCoordinate2DMake( CLLocationDegrees(Float(userBreifVw.userDetails.latitude!)!),CLLocationDegrees(Float(userBreifVw.userDetails.longitude!)!))

        zoomTheMapToCoordinates(coordinate:coordinate)
    }
    
    @IBAction func gridLayoutBtn(_ sender: UIButton) {
        updateTheViewForNavBar(selectedState: LayoutType.grid)
        listCollectionVw.reloadData()
    }
    
    @IBAction func listLayoutBtnTapped(_ sender: UIButton) {
        updateTheViewForNavBar(selectedState: LayoutType.list)
        listCollectionVw.reloadData()
    }
    
    
    @IBAction func mapBtnTapped(_ sender: Any) {
        
        updateTheViewForNavBar(selectedState: LayoutType.map)
    }
    
    @IBAction func userBriefButtonTapped(_ sender: UIButton) {
        delegate?.goToTheDetailView(displayData: userBreifVw.userDetails)
    }
    
    func updateTheViewForNavBar(selectedState:LayoutType){
        if (selectedLayoutType == LayoutType.map &&  (selectedState == LayoutType.list || selectedState == LayoutType.grid)) {
            delegate?.listViewTapped()
            showTheMapView(show: false)
            showTheUserBriefView(show: false)
        }
        else if (selectedState == LayoutType.map &&  (selectedLayoutType == LayoutType.list || selectedLayoutType == LayoutType.grid)){
            delegate?.mapViewTapped()
            showTheMapView(show: true)
            if userBreifVw.userDetails != nil {
                showTheUserBriefView(show: true)
            }
        }
        
        selectedLayoutType = selectedState
        
        gridLayoutBtn.alpha = 0.5
        listLayoutbtn.alpha = 0.5
        mapBtn.alpha = 0.5
        
        switch selectedState {
        case .list:
            listCollectionVw.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            listLayoutbtn.alpha = 1.0
            break
            
        case .grid:
            listCollectionVw.backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
            gridLayoutBtn.alpha = 1.0
            break
            
        case .map:
            mapBtn.alpha = 1.0
            break
        }
    }
    
    func showTheMapView(show:Bool){
        mapViewTraillingConstraint.constant = (show) ? 0 : UIScreen.main.bounds.size.width
        UIView.animate(withDuration: 0.6) { 
            self.layoutIfNeeded()
        }
    }
    
    func zoomTheMapToCoordinates(coordinate: CLLocationCoordinate2D) {
        let region:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1000000, 1000000)
        mapView.setRegion(region, animated: true)
    }
    
    func zoomTheMapToTheUser(userDetails:UserData){
        
        showTheUserBriefView(show: true)
        
        userBreifVw.userDetails = userDetails
        zoomTheMapToCoordinates(coordinate:CLLocationCoordinate2DMake( CLLocationDegrees(Float(userDetails.latitude!)!),CLLocationDegrees(Float( userDetails.longitude!)!)))
    }
    
    func showTheUserBriefView(show:Bool){
        selectionAnnotationViewBottomConstraint.constant = (show) ? 0 : -130
        UIView.animate(withDuration: 0.4) {
            self.layoutIfNeeded()
        }
    }
    
    func showLoaderView(show:Bool){
        loaderContainerView.isHidden = !show
    }
    
    // MARK:- Search Bar delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedStr = searchBar.text!
    }
    
    // MARK:- Keyboard notification
    
    @objc func keyboardWillShow (notification:NSNotification){
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        self.listCollectionVwBottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide (notification:NSNotification){
        self.listCollectionVwBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
}
