//
//  DetailViewController.swift
//  Travel App
//
//  Created by Patricia Fiona on 30/05/22.
//

import UIKit

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {


    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var placeLikes: UILabel!
    @IBOutlet weak var bookmarkButtonContainer: UIView!
    @IBOutlet weak var placeInfoContainer: UIView!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var gradientTranparent: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeDetail: UILabel!
    
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var galeryCollectionView: UICollectionView!
    
    var place: Places?
    var didLayout = false
    var isBookmarked = false
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIsBookmarked()
        setDisplayData()
        setMap()
        
        reviewTableView.dataSource = self
        galeryCollectionView.dataSource = self
        
        reviewTableView.isHidden = false
        galeryCollectionView.isHidden = true
        mapKitView.isHidden = true
        
        Utils().setViewRoundedShadow(placeInfoContainer, 0.05)
        Utils().setViewRoundedShadow(bookmarkButtonContainer, 0.2)
    }
    
    @IBAction func onBookmarkClick(_ sender: UIButton) {
        setBookmarkData()
    }
    
    private func checkIsBookmarked(){
        let placeId = place!.id as Int
        let myBookmarks = userDefaults.object(forKey: "myBookmarks") as? [Int]
        
        if(myBookmarks != nil){
            isBookmarked = myBookmarks!.contains(placeId)
        }
        
        if(isBookmarked){
            bookmarkButton.tintColor = UIColor.red
        }else{
            bookmarkButton.tintColor = UIColor.lightGray
        }
    }
    
    private func setBookmarkData(){
        var updatedData = [Int]()
        let placeId = place!.id as Int
        let myBookmarks = userDefaults.object(forKey: "myBookmarks") as? [Int]
        
        if(myBookmarks != nil){
            if myBookmarks!.contains(placeId) {
                //remove bookmark
                updatedData = myBookmarks!.filter { $0 != placeId }
            }else{
                //add bookmark
                updatedData = myBookmarks!
                updatedData += [placeId]
            }
        }else{
            updatedData = [placeId]
        }
        userDefaults.set(updatedData, forKey: "myBookmarks")
        checkIsBookmarked()
    }
    
    override func viewWillLayoutSubviews() {
        setImageRounded(gradientTranparent)
        setImageRounded(placeImage)
        
        if !self.didLayout {
            self.didLayout = true // only need to do this once
            self.reviewTableView.reloadData()
            self.galeryCollectionView.reloadData()
        }
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        setImageRounded(gradientTranparent)
        setImageRounded(placeImage)
    }
    
    private func setMap(){
        let location = CLLocationCoordinate2D(latitude: (place?.latitude)!,
                                              longitude: (place?.longitude)!)
            
        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let region = MKCoordinateRegion(center: location, span: span)
        mapKitView.setRegion(region, animated: true)
            
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = place?.name
        annotation.subtitle = place?.address
        mapKitView.addAnnotation(annotation)
    }
    
    private func setDisplayData(){
        if let data = place {
            placeName.text = place?.name
            placeAddress.text = place?.address
            placeDetail.text = place?.description
            
            let likes = place?.like!
            placeLikes.text = "\(likes ?? 0)"
            
            FetchImageURL().setDetailImageToImageView(imageContainer: placeImage, imageUrl: "\(String(describing: data.image))")
            setImageRounded(gradientTranparent)
        }
    }
    
    func setImageRounded(_ obj: AnyObject){
        let rectShape = CAShapeLayer()
        rectShape.bounds = obj.frame
        rectShape.position = obj.center
        rectShape.path = UIBezierPath(roundedRect: obj.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 30, height: 30)).cgPath
        obj.layer.mask = rectShape
    }
    
    @IBAction func onSegmentChange(_ sender: UISegmentedControl) {
        let index = (sender as AnyObject).selectedSegmentIndex
        
        switch index{
        case 0:
            // Show review
            reviewTableView.isHidden = false
            galeryCollectionView.isHidden = true
            mapKitView.isHidden = true
            break
        case 1:
            // show galery
            reviewTableView.isHidden = true
            galeryCollectionView.isHidden = false
            mapKitView.isHidden = true
            break
        case 2:
            // show map
            reviewTableView.isHidden = true
            galeryCollectionView.isHidden = true
            mapKitView.isHidden = false
            break
        default:
            print("Segment index Index out of range")
            break
        }
    }
    

}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filteredTableData = reviews.filter {
            $0.placeID == place?.id
        }
        return filteredTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewTableViewCell {
        
            let filteredTableData = reviews.filter {
                $0.placeID == place?.id
            }
            let review = filteredTableData[indexPath.row]
            cell.reviewTitle.text = review.title
            cell.reviewDetail.text = review.description
            cell.reviewUsername.text = review.username
            cell.reviewProfile.image = review.photo
        
            cell.reviewProfile.layer.cornerRadius = cell.reviewProfile.frame.height / 2
            cell.reviewProfile.clipsToBounds = true
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let filteredTableData = galeries.filter {
            $0.placeID == place?.id
        }
        return filteredTableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "GaleryCollection",
            for: indexPath
          ) as! GaleryCollectionViewCell
          
        let filteredTableData = galeries.filter {
            $0.placeID == place?.id
        }
        
        let data = filteredTableData[indexPath.row]
        
        FetchImageURL().setImageToImageView(imageContainer: cell.galeryImage, imageUrl: "\(String(describing: data.placeImage))")
            
          return cell
    }
    
}
