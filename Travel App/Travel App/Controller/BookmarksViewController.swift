//
//  ViewController.swift
//  Travel App
//
//  Created by Patricia Fiona on 30/05/22.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    struct PropertyKeys {
        static let bookmarkCell = "BookmarkCell"
        static let showPlacesDetail = "ShowBookmarkDetail"
    }
        
    private let url = "https://tourism-api.dicoding.dev/list"
    var placesSpace = APIData(){
        didSet{
            DispatchQueue.main.async {
                self.bookmarkTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        FetchData().fetchData(urlForFetchingData: url, completionHandler: {
            placesArray in self.placesSpace = placesArray
        })
        
        super.viewDidLoad()
        
        //set places table
        bookmarkTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bookmarkTableView.reloadData()
        
        let myBookmarks = UserDefaults.standard.object(forKey: "myBookmarks") as? [Int]
        
        if(myBookmarks != nil){
            if(myBookmarks!.count > 0){
                noDataImage.isHidden = (myBookmarks != nil)
                bookmarkTableView.isHidden = (myBookmarks == nil)
            }else{
                noDataImage.isHidden = false
                bookmarkTableView.isHidden = true
            }
        }else{
            noDataImage.isHidden = false
            bookmarkTableView.isHidden = true
        }
        
    }

}

extension BookmarksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let myBookmarks = UserDefaults.standard.object(forKey: "myBookmarks") as? [Int]
        if(myBookmarks == nil){
            return 0
        }
        
        let filteredData = placesSpace.places.filter {
            myBookmarks!.contains($0.id)
        }
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.bookmarkCell, for: indexPath) as? PlacesTableViewCell {
            let myBookmarks = UserDefaults.standard.object(forKey: "myBookmarks") as? [Int]
            
            if(myBookmarks != nil){
                print("Data mentah: \(placesSpace.places)")
                let filteredData = placesSpace.places.filter {
                    myBookmarks!.contains($0.id)
                }
                
                let place = filteredData[indexPath.row]
                cell.placeName?.text = place.name
                cell.placeDetail.text = place.description
                cell.placeLikes.text = "\(String(describing: Int(place.like!) ))"
                FetchImageURL().setImageToImageView(imageContainer: cell.placesImage, imageUrl: "\(String(describing: place.image))")
                
                //make rounded
                cell.placesImage.clipsToBounds = true
                cell.placesImage.layer.cornerRadius = 20
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = bookmarkTableView.indexPathForSelectedRow,
           segue.identifier == PropertyKeys.showPlacesDetail {
            let detailPlaceViewController = segue.destination as! DetailViewController

            let myBookmarks = UserDefaults.standard.object(forKey: "myBookmarks") as? [Int]
            let filteredBookmarkData = placesSpace.places.filter {
                myBookmarks!.contains($0.id)
            }
            detailPlaceViewController.place = filteredBookmarkData[indexPath.row]
        }
    }
    
}

