//
//  TestTableViewController.swift
//  Kaew Ruam Chor
//
//  Created by Lapp on 17/12/2560 BE.
//  Copyright © 2560 SSRU. All rights reserved.
//

import UIKit
import  Alamofire
import Social
import MobileCoreServices

class TestTableViewController: UITableViewController {
    var myFacultyId = ""
    var myFaculty = ""
    var myMajorId = ""
    var myMajor = ""
    var myCatId = ""
    var myLevelId = ""
    var myYear = ""
    var mySec = ""
    var myDegree = ""
    var myLevel = ""
    var myPrefix = ""
    var myEngFname = ""
    var myEngLname = ""
    var myJob = ""
    var myStatus = ""
    var myHouseNumber = ""
    var myMoo = ""
    var myAlley = ""
    var myStreet = ""
    var myDistrict = ""
    var myAmphur = ""
    var myProvince = ""
    var myZipcode = ""
    var myPhone = ""
    var myEmail = ""
    var myFacebook = ""
    var myLine = ""
    var myPhoto = ""
    var myFname = ""
    var myLname = ""
    var myLat = ""
    var myLng = ""
    var myBirthday = ""
    var totalEdu:Int = 0
    
    let http = Http()
    
    
    
    let defaultValues = UserDefaults.standard
    
    var labelsPersonal = ["วันเกิด","คำนำหน้าชื่อ","ชื่ออังกฤษ","นามสกุลอังกฤษ","อาชีพ","สถานะ"]
    var labelsAddress = ["บ้านเลขที่","หมู่","ซอย","ถนน","แขวง/ตำบล","เขต/อำเภอ","จังหวัด","รหัสไปรษณีย์"]
    var labelsEdu = ["คณะ","สาขา","หลักสูตร","ระดับการศึกษา","ปีที่เข้าศึกษา","หมู่เรียน",""]
    var labelsContact = ["เบอร์โทร","อีเมล","Facebook","Line"]
    var mStudent:NSDictionary = [:]
    
    func doClose(alert: UIAlertAction){
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareFacebook(_ sender: UIBarButtonItem) {
        customActivityIndicatory(self.view, startAnimate: true)
        UIApplication.shared.beginIgnoringInteractionEvents()
        let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
        vc?.add(URL(string: "https://reg.ssru.ac.th/ssru80th"))
        
        self.present(vc!, animated: true, completion: nil)
        customActivityIndicatory(self.view, startAnimate: false)
       UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "edit") {
            let vc = segue.destination as! EditTVC
            vc.data = mStudent
        }
        if (segue.identifier == "viewLargeImage") {
            let vc = segue.destination as! ProfileImageVC
            vc.photo = myPhoto
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ข้อมูลศิษย์เก่า"
        tableView.allowsSelection = false
        loadData()
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
      
        if (NotifyDataChange.sharedInstance.shouldReload) {
           
            loadData()
            NotifyDataChange.sharedInstance.shouldReload = false
        }
        
        
        
    }
    
    private func loadData() {
        customActivityIndicatory(self.view, startAnimate: true)
        UIApplication.shared.beginIgnoringInteractionEvents()

        let stu_id = defaultValues.string(forKey: "stu_id")
        let parameters: Parameters=["id":stu_id!]
        let url = http.getBaseUrl() + "getstudent.php"
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON
            {
                response in
                if let result = response.result.value {
                    
                    let jsonData = result as! NSDictionary
                    let student = jsonData.value(forKey: "msg") as! NSDictionary
                   
                // self.totalEdu = studentObj.count
                    
                    self.mStudent = student
                    
                    self.myBirthday = student.value(forKey: "stu_birthdaytext") as! String
                    self.myFacultyId = student.value(forKey: "stu_facultyid") as! String
                    self.myMajorId = student.value(forKey: "stu_majorid") as! String
                    self.myLevelId = student.value(forKey: "stu_levelid") as! String
                    self.myCatId = student.value(forKey: "stu_catid") as! String
                    self.myLevel = student.value(forKey: "level_name") as! String
                    self.myDegree = student.value(forKey: "degree_name") as! String
                    self.myFname = student.value(forKey: "stu_fname") as! String
                    self.myLname = student.value(forKey: "stu_lname") as! String
                    self.myFaculty = student.value(forKey: "fa_thainame") as! String
                    self.myMajor = student.value(forKey: "ma_thainame") as! String
                    self.mySec = student.value(forKey: "stu_sec") as! String
                    self.mySec = "0" + self.mySec
                    self.myYear = student.value(forKey: "stu_year") as! String
                    self.myPrefix = student.value(forKey: "stu_prefix") as! String
                    self.myEngFname = student.value(forKey: "stu_engfname") as! String
                    self.myEngLname = student.value(forKey: "stu_englname") as! String
                    self.myJob = student.value(forKey: "stu_job") as! String
                    self.myStatus = student.value(forKey: "stu_statustext") as! String
                    self.myHouseNumber = student.value(forKey: "stu_housenumber") as! String
                    self.myMoo = student.value(forKey: "stu_moo") as! String
                    self.myAlley = student.value(forKey: "stu_alley") as! String
                    self.myStreet = student.value(forKey: "stu_street") as! String
                    self.myDistrict = student.value(forKey: "stu_district") as! String
                    self.myAmphur = student.value(forKey: "stu_amphur") as! String
                    self.myProvince = student.value(forKey: "stu_province") as! String
                    self.myZipcode = student.value(forKey: "stu_zipcode") as! String
                    self.myPhone = student.value(forKey: "stu_phonenumber") as! String
                    self.myEmail = student.value(forKey: "stu_email") as! String
                    self.myFacebook = student.value(forKey: "stu_facebook") as! String
                    self.myLine = student.value(forKey: "stu_line") as! String
                    self.myPhoto = student.value(forKey: "stu_photo") as! String
                    self.myLat = student.value(forKey: "stu_latitude") as! String
                    self.myLng = student.value(forKey: "stu_longtitude") as! String
                    
                    
                    //Set data for find friends
                    GetFriends.sharedInstance.facultyId = self.myFacultyId
                    GetFriends.sharedInstance.majorId = self.myMajorId
                    GetFriends.sharedInstance.levelId = self.myLevelId
                    GetFriends.sharedInstance.catId = self.myCatId
                    GetFriends.sharedInstance.year = self.myYear
                    GetFriends.sharedInstance.sec = self.mySec
                    
                    
                    
                    CheckLocation.sharedInstance.lat = self.myLat
                    CheckLocation.sharedInstance.lng = self.myLng
                    
                    CheckPhoto.sharedInstance.photo = self.myPhoto
                    
                    
                    self.tableView.reloadData()
                    customActivityIndicatory(self.view, startAnimate: false)
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                } else {
                    //Loading error
                    let title = "ขออภัย"
                    let message = "ระบบขัดข้อง"
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: self.doClose)
                    
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    customActivityIndicatory(self.view, startAnimate: false)
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                }
                
                
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        switch (section) {
        case 1: title = "ข้อมูลการศึกษา"
            break
        case 2: title = "ข้อมูลส่วนตัว"
            break
        case 3: title = "ช่องทางการติดต่อ"
            break
        case 4: title = "ที่อยู่"
            break
        case 5: title = ""
            break
        case 0: title = ""
            break
        default:
            break
        }
        return title
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch (section) {
        case 1: count = labelsEdu.count
            break
        case 2: count = labelsPersonal.count
            break
        case 3: count = labelsContact.count
            break
        case 4: count = labelsAddress.count
            break
        case 5: count = 2
            break
        case 0: count = 1
            break
        default:
            break
        }
        
        return count
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {

        print("viewLargeImage")
        performSegue(withIdentifier: "viewLargeImage", sender: nil)
        
    }
    
    func doLogout(alert: UIAlertAction){
        defaultValues.set(false,forKey:"isLogin")

dismiss(animated: true, completion: nil)    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ButtonTableViewCell
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! ProfileTableViewCell
          let cell4 = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! ChangeCertTableViewCell
        
        if(indexPath.section == 1) {
            
           
            if (indexPath.row != 6) {
            cell.myLabel?.text = labelsEdu[indexPath.row]
            cell.myText?.text = "..."
            if (indexPath.row == 0) {
                cell.myText?.text = myFaculty
            } else if (indexPath.row == 1) {
                cell.myText?.text = myMajor
            } else if (indexPath.row == 2) {
                cell.myText?.text = myDegree
            } else if (indexPath.row == 3) {
                cell.myText?.text = myLevel
            } else if (indexPath.row == 4) {
                cell.myText?.text = myYear
            } else if (indexPath.row == 5) {
                cell.myText?.text = mySec
            }
            return cell
            } else {
               
                
                
            cell4.myButton.setTitle("เปลี่ยนข้อมูลการศึกษา", for: .normal)
            cell4.onButtonTapped = {
                self.performSegue(withIdentifier: "cert", sender: nil)
            }
                
                if(totalEdu > 1) {
                    
                    //cell4.isHidden = false
                    
                } else {
                   // cell4.isHidden = true
                    
                }
                return cell4
            }
        } else if (indexPath.section == 2){
            
            cell.myLabel?.text = labelsPersonal[indexPath.row]
            cell.myText?.text = "..."
            if (indexPath.row == 0) {
                cell.myText?.text = myBirthday
            } else if (indexPath.row == 1) {
                cell.myText?.text = myPrefix
            } else if (indexPath.row == 2) {
                cell.myText?.text = myEngFname
            } else if (indexPath.row == 3) {
                cell.myText?.text = myEngLname
            } else if (indexPath.row == 4) {
                cell.myText?.text = myJob
            } else if (indexPath.row == 5) {
                cell.myText?.text = myStatus
            }
            return cell
        } else if (indexPath.section == 3) {
            cell.myLabel?.text = labelsContact[indexPath.row]
            cell.myText?.text = "..."
            if (indexPath.row == 0) {
                cell.myText?.text = myPhone
            } else if (indexPath.row == 1) {
                cell.myText?.text = myEmail
            } else if (indexPath.row == 2) {
                cell.myText?.text = myFacebook
            } else if (indexPath.row == 3) {
                cell.myText?.text = myLine
            }
            return cell
        } else if (indexPath.section == 4) {
            cell.myLabel?.text = labelsAddress[indexPath.row]
            cell.myText?.text = "..."
            if (indexPath.row == 0) {
                cell.myText?.text = myHouseNumber
            } else if (indexPath.row == 1) {
                cell.myText?.text = myMoo
            } else if (indexPath.row == 2) {
                cell.myText?.text = myAlley
            } else if (indexPath.row == 3) {
                cell.myText?.text = myStreet
            } else if (indexPath.row == 4) {
                cell.myText?.text = myDistrict
            } else if (indexPath.row == 5) {
                cell.myText?.text = myAmphur
            } else if (indexPath.row == 6) {
                cell.myText?.text = myProvince
            } else if (indexPath.row == 7) {
                cell.myText?.text = myZipcode
            }
            return cell
        } else if (indexPath.section == 5) {
            if (indexPath.row == 0) {
                cell2.myButton.setTitle("แก้ไขข้อมูล", for: .normal)
                cell2.myButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                cell2.onButtonTapped = {
                    self.performSegue(withIdentifier: "edit", sender: nil)
                }
            } else if (indexPath.row == 1) {
                cell2.myButton.setTitle("ออกจากระบบ", for: .normal)
                cell2.myButton.setTitleColor(UIColor.red, for: .normal)
                cell2.myButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                cell2.onButtonTapped = {
                    let title = "แจ้งเตือน"
                    let message = "คุณต้องการออกจากระบบใช่หรือไม่"
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "ออกจากระบบ", style: .default, handler: self.doLogout)
                    OKAction.setValue(UIColor.red, forKey: "titleTextColor")
                    let cancelAction = UIAlertAction(title: "ยกเลิก", style: .default, handler: nil)
                    alertController.addAction(cancelAction)
                    alertController.addAction(OKAction)

                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
            return cell2
        } else if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell3.myFullName?.text = myFname + " " + myLname
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))

                cell3.myImage.isUserInteractionEnabled = true
                cell3.myImage.addGestureRecognizer(tapGestureRecognizer)
                cell3.myImage.layer.borderWidth = 2
                cell3.myImage.layer.masksToBounds = false
               cell3.myImage.layer.borderColor = UIColor.white.cgColor
                cell3.myImage.layer.cornerRadius = cell3.myImage.frame.height/2
                cell3.myImage.clipsToBounds = true
                if (myPhoto != "") {
                    //have photo
                    if let decodedData = Data(base64Encoded: myPhoto, options: .ignoreUnknownCharacters) {
                        //photo is valid
                        cell3.myImage.image = UIImage(data: decodedData)
                    } else {
                        //photo is invalid
                        cell3.myImage.image = UIImage(named:"profile.png")
                        
                    }
                } else {
                    // don't have photo
                    cell3.myImage.image = UIImage(named:"profile.png")
                    
                }
            }
            return cell3
        }
        return cell
    }
    
    
}
