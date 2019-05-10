import UIKit
import Alamofire

class EditTVC: UITableViewController,UIPickerViewDataSource, UIPickerViewDelegate , UITextFieldDelegate  {
   
    
    var statusPicker: UIPickerView = UIPickerView()
    var provincePicker: UIPickerView = UIPickerView()
    var amphurPicker:UIPickerView = UIPickerView()
    var districtPicker:UIPickerView = UIPickerView()
    var jobPicker:UIPickerView = UIPickerView()
    let http = Http()
    
    
    
    
    
    //the defaultvalues to store user data
    let defaultValues = UserDefaults.standard
    
    //Outlet for textfield
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var prefixTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var fbTextField: UITextField!
    
    @IBOutlet weak var lineTextField: UITextField!
    @IBOutlet weak var engFName: UITextField!
    
    @IBOutlet weak var engLName: UITextField!
    
    @IBOutlet weak var houseNumberTextField: UITextField!
    @IBOutlet weak var mooTextField: UITextField!
    @IBOutlet weak var alleyTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var amphurTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    
    @IBOutlet weak var jobTextField: UITextField!
    
    
    var statuses:[String] = ["มีชีวิต","ถึงแก่กรรม"]
    var provinces:[String] = []
    var provincesId:[String] = []
    var amphurs:[String] = []
    var amphursId:[String] = []
    var districts:[String] = []
    var districtsId:[String] = []
    var zipcodes:[String] = []
    var jobs:[String] = []

    var data:NSDictionary = [:]

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10
        
    }
    
    func cancelPicker () {
        self.view.endEditing(true)

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.allowsSelection = false
        amphurTextField.isUserInteractionEnabled = false
        districtTextField.isUserInteractionEnabled = false
        phoneTextField.delegate = self
        NotifyDataChange.sharedInstance.shouldReload = false
        
        
        
        
        
        let pickerUrl2 = http.getBaseUrl() + "getjobs.php"
        
        Alamofire.request(pickerUrl2, method: .post).responseJSON
            {
                response in
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    let facultyObj = jsonData.value(forKey: "msg") as! NSArray
                  
                    for  faculty in facultyObj {
                        let fa = faculty as! NSDictionary
                        
                        let jobName = fa.value(forKey: "oc_desc") as! String
                        
                        
                        self.jobs.append(jobName)
                    }
                }
        }
        
        
        
        
        let pickerUrl = http.getBaseUrl() + "getprovinces.php"

        Alamofire.request(pickerUrl, method: .post).responseJSON
            {
                response in
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    let facultyObj = jsonData.value(forKey: "msg") as! NSArray

                    for  faculty in facultyObj {
                        let fa = faculty as! NSDictionary
                        
                       let faName = fa.value(forKey: "pro_thainame") as! String
                        let faId = fa.value(forKey: "pro_geocode") as! String

                        self.provinces.append(faName)
                        self.provincesId.append(faId)
                }
        }
        }
        
        
        
        statusPicker.delegate = self
        statusPicker.dataSource = self
        provincePicker.delegate = self
        provincePicker.dataSource = self
        amphurPicker.delegate = self
        amphurPicker.dataSource = self
        districtPicker.delegate = self
        districtPicker.dataSource = self
        jobPicker.delegate = self
        jobPicker.dataSource = self
        
        emailTextField.keyboardType = UIKeyboardType.emailAddress
        phoneTextField.keyboardType = UIKeyboardType.numberPad
        mooTextField.keyboardType = UIKeyboardType.numberPad
        postalCodeTextField.keyboardType = UIKeyboardType.numberPad
        
        statusTextField.inputView = statusPicker
        
        provinceTextField.inputView = provincePicker
        amphurTextField.inputView = amphurPicker
        districtTextField.inputView = districtPicker
        
        
        jobTextField.inputView = jobPicker
        prefixTextField.text = data.value(forKey: "stu_prefix") as? String
        engFName.text = data.value(forKey: "stu_engfname") as? String
        engLName.text = data.value(forKey: "stu_englname") as? String
        jobTextField.text = data.value(forKey: "stu_job") as? String
        statusTextField.text = data.value(forKey: "stu_statustext") as? String
        houseNumberTextField.text = data.value(forKey: "stu_housenumber") as? String
        mooTextField.text = data.value(forKey: "stu_moo") as? String
        alleyTextField.text = data.value(forKey: "stu_alley") as? String
        streetTextField.text = data.value(forKey: "stu_street") as? String
        districtTextField.text = data.value(forKey: "stu_district") as? String
        amphurTextField.text = data.value(forKey: "stu_amphur") as? String
        provinceTextField.text = data.value(forKey: "stu_province") as? String
        postalCodeTextField.text = data.value(forKey: "stu_zipcode") as? String
        emailTextField.text = data.value(forKey: "stu_email") as? String
        phoneTextField.text = data.value(forKey: "stu_phonenumber") as? String
        fbTextField.text = data.value(forKey: "stu_facebook") as? String
        lineTextField.text = data.value(forKey: "stu_line") as? String
  
    }
    
    
    
    
    
    
    //Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1

    }
    
    
    
  
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == statusPicker {
            return statuses.count
        }
        if pickerView == provincePicker {
            return provinces.count
        }
        if pickerView == amphurPicker {
            return amphurs.count
        }
        if pickerView == districtPicker {
            return districts.count
        }
        if pickerView == jobPicker {
            return jobs.count
        }
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == statusPicker {
            statusTextField.text = statuses[row]
        }
        
        if pickerView == jobPicker {
           
            jobTextField.text = jobs[row]
        }
        
        if pickerView == provincePicker {
            amphurTextField.isUserInteractionEnabled = true
            districtTextField.isUserInteractionEnabled = false
            provinceTextField.text = provinces[row]
            amphurTextField.text = ""
            districtTextField.text = ""
            let pickerUrl = http.getBaseUrl() + "getamphurs.php"
            let parameters: Parameters=["id":provincesId[row]]

            Alamofire.request(pickerUrl, method: .post,parameters:parameters).responseJSON
                {
                    response in
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        let amphurObj = jsonData.value(forKey: "msg") as! NSArray
                        self.amphurs.removeAll()
                        self.amphursId.removeAll()
                        for  amphur in amphurObj {
                            let am = amphur as! NSDictionary
                            let amId = am.value(forKey: "am_id") as! String
                            let amName = am.value(forKey: "am_thainame") as! String
                            self.amphurs.append(amName)
                            self.amphursId.append(amId)
                        }
                        self.amphurPicker.reloadAllComponents()
                    }
            }
            
        }
        if pickerView == amphurPicker {
            districtTextField.isUserInteractionEnabled = true
            amphurTextField.text = amphurs[row]
            districtTextField.text = ""
            let pickerUrl = http.getBaseUrl() + "getdistricts.php"
            let parameters: Parameters=["id":amphursId[row]]
            
            Alamofire.request(pickerUrl, method: .post,parameters:parameters).responseJSON
                {
                    response in
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        let districtObj = jsonData.value(forKey: "msg") as! NSArray
                        self.districts.removeAll()
                        self.districtsId.removeAll()
                        self.zipcodes.removeAll()
                        for  district in districtObj {
                            let dt = district as! NSDictionary
                            let dtId = dt.value(forKey: "dis_id") as! String
                            let dtName = dt.value(forKey: "dis_thainame") as! String
                            let dtZip = dt.value(forKey: "dis_zipcode") as! String
                            self.districts.append(dtName)
                            self.districtsId.append(dtId)
                            self.zipcodes.append(dtZip)
                        }
                        self.districtPicker.reloadAllComponents()
                    }
            }
        }
        if pickerView == districtPicker {
            districtTextField.text = districts[row]
            postalCodeTextField.text = zipcodes[row]
        }
        
    
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView == statusPicker {
            return statuses[row]
        }
        if pickerView == provincePicker {
            return provinces[row]
        }
        if pickerView == amphurPicker {
            return amphurs[row]
        }
        if pickerView == districtPicker {
            return districts[row]
        }
        if pickerView == jobPicker {
            return jobs[row]
        }
        return ""
        
        
        
    }
   

    
    
    
    
    
    //When user touches save button
    @IBAction func update(_ sender: UIBarButtonItem) {
        
        
        customActivityIndicatory((self.navigationController?.view)!, startAnimate: true)
        

        
        //Make activity ignore touch
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Get user id , so we khow which user is updated
        let stu_id = defaultValues.string(forKey: "stu_id")
        
        var status = ""
        switch (statusTextField.text!) {
        case "มีชีวิต":
            status = "1"
            break
        case "ถึงแก่กรรม":
            status = "0"
            break
        default:
            break
            
        }

        
        //Parameters for updating
        let parameters: Parameters=["id":stu_id!,
                                    "email":emailTextField.text!,
                                    "prefix":prefixTextField.text!,
                                    "engfname":engFName.text!,
                                    "englname":engLName.text!,
                                    "housenumber":houseNumberTextField.text!,
                                    "moo":mooTextField.text!,
                                    "alley":alleyTextField.text!,
                                    "street":streetTextField.text!,
                                    "district":districtTextField.text!,
                                    "amphur":amphurTextField.text!,
                                    "province":provinceTextField.text!,
                                    "zipcode":postalCodeTextField.text!,
                                    "facebook":fbTextField.text!,
                                    "line":lineTextField.text!,
                                    "job": jobTextField.text!,
                                    "status":status,
                                    "phonenumber":phoneTextField.text!
            
                                    ]
        
        
    
        let url = http.getBaseUrl() + "update.php"
       
        //making a post request
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON
            {
                response in
                UIApplication.shared.endIgnoringInteractionEvents()
                customActivityIndicatory((self.navigationController?.view)!, startAnimate: false)
                NotifyDataChange.sharedInstance.shouldReload = true
                _ = self.navigationController?.popViewController(animated: true)

        
        
        
      

    }
    
    
    
    
  
    
    
 
    
    
    
}
}
