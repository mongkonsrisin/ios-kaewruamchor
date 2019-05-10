import UIKit
import MapKit
import Alamofire

class MapVC: UIViewController, MKMapViewDelegate   {
    
    var data: NSData?
    let defaultValues = UserDefaults.standard
    var myLat = 0.0
    var myLng = 0.0
    
    let http = Http()
    @IBOutlet weak var mapView: MKMapView!
    
    
    func gotoMarker(alert: UIAlertAction){
        performSegue(withIdentifier: "goToMarker", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadMap()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(NotifyDataChange.sharedInstance.shouldReloadMap) {
            let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            myLat = 0.0
            myLng = 0.0
            loadMap()
            NotifyDataChange.sharedInstance.shouldReloadMap = false
        }
    }
  
    private func loadMap() {
        customActivityIndicatory(self.view, startAnimate: true)
        UIApplication.shared.beginIgnoringInteractionEvents()
        let lat = CheckLocation.sharedInstance.lat
        let lng = CheckLocation.sharedInstance.lng
        if(lat == "" || lng == "") {
            //No location
            customActivityIndicatory(self.view, startAnimate: false)
            UIApplication.shared.endIgnoringInteractionEvents()
            let title = "ข้อผิดพลาด"
            let message = "กรุณาปักหมุดที่อยู่ก่อนครับ"
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "ตกลง", style: .default, handler: self.gotoMarker)
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            //have location
            let latFromServer = CheckLocation.sharedInstance.lat
            let lngFromServer = CheckLocation.sharedInstance.lng
            
            if let latToZoom = Double(latFromServer) , let lngToZoom = Double(lngFromServer)
            {
                //location is valid
                myLat = latToZoom
                myLng = lngToZoom
            } else {
                //location is invalid use SSRU instead
                myLat = 13.7765
                myLng = 100.5090
            }
            
            
            let parameters: Parameters=["facultyid":GetFriends.sharedInstance.facultyId,
                                        "majorid":GetFriends.sharedInstance.majorId,
                                        "levelid":GetFriends.sharedInstance.levelId,
                                        "catid":GetFriends.sharedInstance.catId,
                                        "sec":GetFriends.sharedInstance.sec,
                                        "year":GetFriends.sharedInstance.year]
            
            let url = http.getBaseUrl() + "getfriendslocation.php"
            
            
            
            Alamofire.request(url, method: .post, parameters: parameters).responseJSON
                {
                    response in
                    
                    if let result = response.result.value {
                        
                        let jsonData = result as! NSDictionary
                        let studentObj = jsonData.value(forKey: "msg") as! NSArray
                        if (studentObj.count == 0) {
                            //No Friend
                            let title = "ข้อผิดพลาด"
                            let message = "ยังไม่มีเพื่อนปักหมุดแผนที่ครับ"
                            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(OKAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                            customActivityIndicatory(self.view, startAnimate: false)
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                        } else {
                            //Have friends
                            
                            for  student in studentObj {
                                
                                let stu = student as! NSDictionary
                                print (stu.count)
                                
                                
                                let lat = stu.value(forKey: "stu_latitude") as! String
                                let lng = stu.value(forKey: "stu_longtitude") as! String
                                let fname = stu.value(forKey: "stu_fname") as! String
                                let lname = stu.value(forKey: "stu_lname") as! String
                                
                                let id = stu.value(forKey: "stu_id") as! String
                                let photo = stu.value(forKey: "stu_photo")
                                    as! String
                                
                                if let mLat = Double(lat) {
                                    if let mLng = Double(lng) {
                                        //lat lng is OK
                                        
                                        if  (photo != "") {
                                            
                                            if let decodedData = Data(base64Encoded: photo, options: .ignoreUnknownCharacters)  {
                                                
                                                let myAnno = Annotation(coordinate: CLLocationCoordinate2DMake(mLat, mLng), title: fname + " " +  lname, subtitle: "", image: UIImage(data:decodedData),myid:id)
                                                myAnno.myid = id
                                                self.mapView.showAnnotations([myAnno], animated: true)
                                            } else {
                                                //cannot decode image
                                                let myAnno = Annotation(coordinate: CLLocationCoordinate2DMake(mLat, mLng), title: fname + " " +  lname, subtitle: "", image: UIImage(named: "profile.png"),myid:id)
                                                myAnno.myid = id
                                                
                                                self.mapView.showAnnotations([myAnno], animated: true)
                                            }
                                            
                                        } else {
                                            //no image
                                            let myAnno = Annotation(coordinate: CLLocationCoordinate2DMake(mLat, mLng), title: fname + " " +  lname, subtitle: "", image: UIImage(named: "profile.png"),myid:id)
                                            myAnno.myid = id
                                            
                                            self.mapView.showAnnotations([myAnno], animated: true)
                                        }
                                        
                                        
                                        
                                    }
                                    
                                }
                                let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
                                let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.myLat,self.myLng)
                                let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
                                self.mapView.setRegion(region, animated: true)
                                customActivityIndicatory(self.view, startAnimate: false)
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                                
                                
                            }
                            
                        }
                        
                    } else {
                        //Server error
                        customActivityIndicatory(self.view, startAnimate: false)
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
            }
            
        } //End if else user no pin
    }
    
    
    func mapView(_ mapView: MKMapView,viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        let identifier = "MyPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if (annotation is MKUserLocation) {
            return nil
        }
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            
        }
        
        
        
        let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let v = annotation as! Annotation
        leftIconView.image = v.image
        annotationView?.leftCalloutAccessoryView = leftIconView
        let calloutButton = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = calloutButton
        return annotationView
        
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let a = view.annotation as? Annotation
            
            self.defaultValues.set(a?.myid, forKey: "friend_id")
            
            performSegue(withIdentifier: "detail", sender: nil)
            
        }
    }
    
    
    
    
    
}









