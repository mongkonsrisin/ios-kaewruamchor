

import UIKit
import Alamofire
import SafariServices

class LoginVC: UIViewController {
    
    let http = Http()
    let defaultValues = UserDefaults.standard
    
    @IBOutlet weak var fnameTextField: UITextField!
    @IBOutlet weak var lnameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
   
    
    func gotoRegister(alert: UIAlertAction){
       
    }
    
    @IBAction func howToEnterPassword(_ sender: UIButton) {
        let title = "แจ้งเตือน"
        let message = "เข้าสู่ระบบ รหัสผ่านคือ วัน/เดือน/ปีเกิด เช่น 05/01/2527"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 15
        loginBtn.clipsToBounds = true

        
        if (defaultValues.value(forKey: "isLogin") == nil) {
        defaultValues.set(false,forKey:"isLogin")
        }
        
       
    }

    
  
 
   
  
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isLogin:Bool = defaultValues.value(forKey: "isLogin") as! Bool
        
        if(isLogin == true) {
            self.performSegue(withIdentifier: "doLogin", sender: nil)
        }

    }
    
    @IBAction func doLogin(_ sender: UIButton) {
        customActivityIndicatory(self.view, startAnimate: true)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let fname = fnameTextField.text!
        let lname = lnameTextField.text!
        let birthday = birthdayTextField.text!
        
        let parameters: Parameters=["fname":fname,"lname":lname,"birthday":birthday]
        let url = http.getBaseUrl() + "auth.php"
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON
            {
                response in
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    if((jsonData.value(forKey: "success") as! Bool)){
                        //Getting id
                        let stu_id = jsonData.value(forKey: "msg") as! String
                        //Saving id for global use
                        self.defaultValues.set(stu_id, forKey: "stu_id")
                        self.defaultValues.set(true,forKey:"isLogin")
                        UIApplication.shared.endIgnoringInteractionEvents()
                        customActivityIndicatory(self.view, startAnimate: false)
                        
                        self.performSegue(withIdentifier: "doLogin", sender: nil)

 
                    } else {
                        let title = "ข้อผิดพลาด"
                        let message = "ไม่พบข้อมูล กรุณาลองใหม่อีกครั้ง"
                        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
                        alertController.addAction(OKAction)
                        let RegisterAction = UIAlertAction(title: "สมัครสมาชิก", style: .default, handler: self.gotoRegister)
                        alertController.addAction(RegisterAction)
                        self.present(alertController, animated: true, completion: nil)
                        UIApplication.shared.endIgnoringInteractionEvents()
                        customActivityIndicatory(self.view, startAnimate: false)

                    }
                } else {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    customActivityIndicatory(self.view, startAnimate: false)
                    
                    let title = "ข้อผิดพลาด"
                    let message = "ระบบขัดข้อง กรุณาลองใหม่อีกครั้ง"
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
                 
                    alertController.addAction(OKAction)
                    

                    self.present(alertController, animated: true, completion: nil)
                    
                }
        } 
        
        
    }
    


}

