//
//  ViewController.swift
//  Travel ID
//
//  Created by Patricia Fiona on 28/07/21.
//

import UIKit

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

class HomeViewController: UIViewController {
    @IBOutlet weak var scrollContainer: UIView!
    @IBOutlet weak var homeBannerImage: UIView!
    @IBOutlet weak var homeBannerSubContainer: UIImageView!
    
    @IBOutlet weak var category01: UIButton!
    @IBOutlet weak var category02: UIButton!
    @IBOutlet weak var category03: UIButton!
    @IBOutlet weak var category04: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var recomendTableView: UITableView!
    
    struct PropertyKeys {
        static let placesCell = "RecomendCell"
        static let showPlacesDetail = "ShowRecomendedPlacesDetail"
    }
    
    var didLayout = false
    
    private let url = "https://tourism-api.dicoding.dev/list"
    var placesSpace = APIData(){
        didSet{
            DispatchQueue.main.async {
                self.recomendTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        FetchData().fetchData(urlForFetchingData: url, completionHandler: {
            placesArray in self.placesSpace = placesArray
        })
        
        super.viewDidLoad()
        
        recomendTableView.dataSource = self
        
        setBannerCorner()
        setCategoryColor()
        setProfileStyle(img: profileImage)
    }
    
    override func viewDidLayoutSubviews() {
        if !self.didLayout {
            self.didLayout = true // only need to do this once
            self.recomendTableView.reloadData()
        }
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        setBannerCorner()
    }
    
    private func setCategoryColor(){
        let catButtons = [category01, category02, category03, category04]
        
        for btn in catButtons{
            btn!.applyGradient(colours: [.systemTeal, .blue])
            btn!.layer.cornerRadius = 10
            btn!.clipsToBounds = true
        }
        
    }
    
    private func setProfileStyle(img: UIImageView){
        var currentHeight: CGFloat?
        
        let group = DispatchGroup()
            group.enter()

            DispatchQueue.main.async {
                currentHeight = img.frame.height
                group.leave()
            }
        
        group.notify(queue: .main) {
            img.layer.cornerRadius = currentHeight! / 2.0
        }
        
    }

    private func setBannerCorner(){
        //get width from scroll container and update it
        var currentWidth: CGFloat?
        
        let group = DispatchGroup()
            group.enter()

            DispatchQueue.main.async {
                currentWidth = self.scrollContainer.frame.size.width
                group.leave()
            }
        
        group.notify(queue: .main) {
            self.homeBannerImage.frame.size.width = currentWidth!
            
            //Container Radius
            DetailPlaceViewController.init().setImageRounded(self.homeBannerImage)
            
            //SubCountainer Radius
            let rectShape02 = CAShapeLayer()
            rectShape02.bounds = self.homeBannerSubContainer.frame
            rectShape02.position = self.homeBannerSubContainer.center
            rectShape02.path = UIBezierPath(roundedRect: self.homeBannerSubContainer.bounds, byRoundingCorners: [.bottomRight, .topLeft], cornerRadii: CGSize(width: 50, height: 50)).cgPath
            self.homeBannerSubContainer.layer.mask = rectShape02
        }
        
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filteredTableData = placesSpace.places.filter {
            recomendedPlace.contains($0.id)
        }
        return filteredTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RecomendCell", for: indexPath) as? RecomendTableViewCell {
        
            let filteredTableData = placesSpace.places.filter {
                recomendedPlace.contains($0.id)
            }
            
            let places = filteredTableData[indexPath.row]
            cell.placeName?.text = places.name
            cell.placeDetail.text = places.description
            cell.placeLike.text = "\(String(describing: Int(places.like!) ))"
            FetchImageURL().setImageToImageView(imageContainer: cell.placeImage, imageUrl: "\(String(describing: places.image))")
            
            //make rounded
            cell.placeImage.clipsToBounds = true
            cell.placeImage.layer.cornerRadius = 20
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = recomendTableView.indexPathForSelectedRow,
           segue.identifier == PropertyKeys.showPlacesDetail {
            let detailPlaceViewController = segue.destination as! DetailPlaceViewController
            
            let filteredTableData = placesSpace.places.filter {
                recomendedPlace.contains($0.id)
            }
            
            detailPlaceViewController.place = filteredTableData[indexPath.row]
        }
    }
    
}

