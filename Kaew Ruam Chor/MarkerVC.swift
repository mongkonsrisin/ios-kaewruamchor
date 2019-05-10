//
//  MarkerVC.swift
//  Kaew Ruam Chor
//
//  Created by Mongkon Srisin on 6/26/2560 BE.
//  Copyright © 2560 SSRU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class MarkerVC: UIViewController , MKMapViewDelegate , UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var lat = 0.0
    var long = 0.0
    let http = Http()
    let defaultValues = UserDefaults.standard


    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet var gestureReconizer: UITapGestureRecognizer!
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

       mapView.delegate = self
        saveBtn.isEnabled = false
        
       

        searchBar.delegate = self
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
       let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(13.7765,100.5090)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        self.mapView.setRegion(region, animated: true)

       
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        customActivityIndicatory(self.view, startAnimate: true)
        UIApplication.shared.beginIgnoringInteractionEvents()
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request:searchRequest)
        activeSearch.start { (response ,error) in
            if response == nil {
                let title = "ข้อผิดพลาด"
                let message = "ไม่พบที่อยู่นี้"
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
                customActivityIndicatory(self.view, startAnimate: false)
                UIApplication.shared.endIgnoringInteractionEvents()
                
            } else {
                let lat = response?.boundingRegion.center.latitude
                let lng = response?.boundingRegion.center.longitude
         
                
                let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
                let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, lng!)
                let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
                self.mapView.setRegion(region, animated: true)
                customActivityIndicatory(self.view, startAnimate: false)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            
        
        }
        
    }
    
    @IBAction func saveMarker(_ sender: UIBarButtonItem) {
       UIApplication.shared.beginIgnoringInteractionEvents()
        customActivityIndicatory((self.navigationController?.view)!, startAnimate: true)
        
        let url = http.getBaseUrl() + "update.php"
        let stu_id = defaultValues.string(forKey: "stu_id")

        
        let parameters: Parameters=["id":stu_id!,
                                   "latitude":lat,
                                   "longtitude":long]
        CheckLocation.sharedInstance.lat = String(lat)
        CheckLocation.sharedInstance.lng = String(long)
        
        //making a post request
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON
            {
                response in
                NotifyDataChange.sharedInstance.shouldReloadMap = true
              

                UIApplication.shared.endIgnoringInteractionEvents()
                customActivityIndicatory((self.navigationController?.view)!, startAnimate: false)
                self.navigationController?.popViewController(animated: true)
                
        }
        

    }
    
    
    
    @IBAction func addMarker(_ sender: UITapGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.title = "ที่อยู่ของคุณ"
        let latitude = coordinate.latitude
        let longtitude = coordinate.longitude
        annotation.coordinate = coordinate
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotation(annotation)
        saveBtn.isEnabled = true
        lat = latitude
        long = longtitude
    
    }
    
   
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    
    
   }
