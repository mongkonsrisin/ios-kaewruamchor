import UIKit
import SpriteKit
import Magnetic
import Social
import MobileCoreServices
import Alamofire
extension CGPoint {
    
    func distance(from point: CGPoint) -> CGFloat {
        return hypot(point.x - x, point.y - y)
    }
    
}

class BubbleVC: UIViewController {
    
    let defaultValues = UserDefaults.standard
    let http = Http()
    var bubbleSize:Float = 50.0
    
    
    
    @IBOutlet weak var magneticView: MagneticView! {
        didSet {
            
            magnetic.magneticDelegate = self
            
        }
    }
    
    
    @IBAction func sharePhoto(_ sender: Any) {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
            let image = renderer.image { ctx in
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            }
          

           // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
            vc?.add(image)
            
            self.present(vc!, animated: true, completion: nil)

        } else {
            // Fallback on earlier versions
        }
  
        
        //Save it to the camera roll
    }
    
    
    
    
    
    var magnetic: Magnetic {
        return magneticView.magnetic
    }
    
    
    func gotoUpload(alert: UIAlertAction){
        performSegue(withIdentifier: "goToUpload", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named:"logo.png")
        let logoView = UIImageView(image:logo)
        logoView.frame = CGRect(x: 0, y: 48, width: 80, height: 100)
        logoView.center.x = self.view.center.x

        view.addSubview(logoView)
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg.jpg")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(backgroundImage, at: 0)
        self.view.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: backgroundImage, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom,multiplier: 1, constant: 0))
        magneticView.backgroundColor = UIColor.clear
        magnetic.backgroundColor = UIColor.clear
        loadBubble()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    if(NotifyDataChange.sharedInstance.shouldReloadPhoto) {
            
        
            
        let speed = magnetic.physicsWorld.speed
        magnetic.physicsWorld.speed = 0
        let sortedNodes = magnetic.children.flatMap { $0 as? Node }.sorted { node, nextNode in
            let distance = node.position.distance(from: magnetic.magneticField.position)
            let nextDistance = nextNode.position.distance(from: magnetic.magneticField.position)
            return distance < nextDistance && node.isSelected
        }
        var actions = [SKAction]()
        for (index, node) in sortedNodes.enumerated() {
            node.physicsBody = nil
            let action = SKAction.run { [unowned magnetic, unowned node] in
                if node.isSelected {
                    let point = CGPoint(x: magnetic.size.width / 2, y: magnetic.size.height + 40)
                    let movingXAction = SKAction.moveTo(x: point.x, duration: 0.2)
                    let movingYAction = SKAction.moveTo(y: point.y, duration: 0.4)
                    let resize = SKAction.scale(to: 0.3, duration: 0.4)
                    let throwAction = SKAction.group([movingXAction, movingYAction, resize])
                    node.run(throwAction) { [unowned node] in
                        node.removeFromParent()
                    }
                } else {
                    node.removeFromParent()
                }
            }
            actions.append(action)
            let delay = SKAction.wait(forDuration: TimeInterval(index) * 0.002)
            actions.append(delay)
        }
        magnetic.run(.sequence(actions)) { [unowned magnetic] in
            magnetic.physicsWorld.speed = speed
        }

        
            
            
        
      
            
           loadBubble()
            
            NotifyDataChange.sharedInstance.shouldReloadPhoto = false
        }
    }
    
    private func loadBubble() {
        
        
        let photo = CheckPhoto.sharedInstance.photo
        
        if (photo == "") {
            //No photo
            customActivityIndicatory(self.view, startAnimate: false)
            UIApplication.shared.endIgnoringInteractionEvents()
            let title = "ข้อผิดพลาด"
            let message = "กรุณาเพิ่มรูปภาพโปรไฟล์ก่อนครับ"
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "ตกลง", style: .default, handler: self.gotoUpload)
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            customActivityIndicatory(self.view, startAnimate: true)
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            
            let url = http.getBaseUrl() + "getfriendsphoto.php"
            
            let parameters: Parameters=["facultyid":GetFriends.sharedInstance.facultyId,
                                        "majorid":GetFriends.sharedInstance.majorId,
                                        "levelid":GetFriends.sharedInstance.levelId,
                                        "catid":GetFriends.sharedInstance.catId,
                                        "sec":GetFriends.sharedInstance.sec,
                                        "year":GetFriends.sharedInstance.year]
           

            Alamofire.request(url, method: .post, parameters: parameters).responseJSON
                {
                    response in
                    
                    if let result = response.result.value {
                        
                        let jsonData = result as! NSDictionary
                        let studentObj = jsonData.value(forKey: "msg") as! NSArray
                        

                        for  student in studentObj {
                            let stu = student as! NSDictionary
                            let photo = stu.value(forKey: "stu_photo") as! String
                            let id = stu.value(forKey: "stu_id") as! String
                            let decodedData = Data(base64Encoded: photo, options: .ignoreUnknownCharacters)
                            let node = CustomNode(text: id, image: UIImage(data:decodedData!), color: UIColor.white, radius: CGFloat(self.bubbleSize))
                            
                            self.magnetic.addChild(node)
                            
                     
                          
                            
                        }
                        customActivityIndicatory(self.view, startAnimate: false)
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
            }
            
        }
        
        
    }
    
    
    
}






extension BubbleVC: MagneticDelegate {
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        self.defaultValues.set(node.text!, forKey: "friend_id")
        node.isSelected = false
        performSegue(withIdentifier: "detail", sender: nil)
    }
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
    }
}



class CustomNode: Node {
    override var image: UIImage? {
        didSet {
            guard let image = image else { return }
            sprite.texture = SKTexture(image: image)
        }
    }
    
    
    override func selectedAnimation() { }
    override func deselectedAnimation() {}
    
    
    
}



