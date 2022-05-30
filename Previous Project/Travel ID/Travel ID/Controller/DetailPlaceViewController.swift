//
//  DetailPlaceViewController.swift
//  Travel ID
//
//  Created by Patricia Fiona on 30/07/21.
//

import UIKit
import MapKit
import CoreLocation

class DetailPlaceViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDisplayData()
        setMap()
        
        reviewTableView.dataSource = self
        galeryCollectionView.dataSource = self
        
        reviewTableView.isHidden = false
        galeryCollectionView.isHidden = true
        mapKitView.isHidden = true
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
            
            FetchImageURL().setDetailImageToImageView(imageContainer: placeImage, imageUrl: "\(String(describing: data.image))")
            setImageRounded(gradientTranparent)
        }
    }
    
    func setImageRounded(_ obj: AnyObject){
        let rectShape = CAShapeLayer()
        rectShape.bounds = obj.frame
        rectShape.position = obj.center
        rectShape.path = UIBezierPath(roundedRect: obj.bounds, byRoundingCorners: [.bottomRight], cornerRadii: CGSize(width: 50, height: 50)).cgPath
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

extension DetailPlaceViewController: UITableViewDataSource {
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

extension DetailPlaceViewController: UICollectionViewDataSource {
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
