//
//  ChangeCertTVC.swift
//  Kaew Ruam Chor
//
//  Created by Lapp on 26/12/2560 BE.
//  Copyright © 2560 SSRU. All rights reserved.
//

import UIKit
import Alamofire

class ChangeCertTVC: UITableViewController {
    
    
  
    
    let http = Http()
    
    var certs:[String] = []
    var fas:[String] = []
    var mas:[String] = []
    var les:[String] = []
    var photo:[String] = []

    
    let defaultValues = UserDefaults.standard
    
    var total:Int = 0
    
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    
    private func loadData() {
       // customActivityIndicatory(self.view, startAnimate: true)
       // UIApplication.shared.beginIgnoringInteractionEvents()
        
        let stu_id = defaultValues.string(forKey: "stu_id")
        let parameters: Parameters=["id":stu_id!]
        let url = http.getBaseUrl() + "listedu.php"
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON
            {
                response in
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    let certObj = jsonData.value(forKey: "msg") as! NSArray
                    self.total = certObj.count
                    
                    for  cert in certObj {
                        
                       
                        
                        
                        let ce = cert as! NSDictionary
                        let id = ce.value(forKey: "stu_id") as! String
                        self.certs.append(id)
                        let fa = ce.value(forKey: "fa_thainame") as! String
                        self.fas.append(fa)
                        let ma = ce.value(forKey: "ma_thainame") as! String
                        self.mas.append(ma)
                        let le = ce.value(forKey: "level_name") as! String
                        self.les.append(le)
                        let logo = ce.value(forKey: "fa_logo") as! String
                        self.photo.append(logo)
                        
                       
                    }
                    
                    self.tableView.reloadData()
                } else {
                    
                    
                }
                
                
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return total
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CertTableViewCell
       
        cell.facultyLabel.text =  fas[indexPath.row]
        cell.majorLabel.text = "สาขา" + mas[indexPath.row]
        cell.levelLabel.text = "ระดับ" + les[indexPath.row]
        cell.majorLabel.textColor = UIColor(red:33/255, green: 150/255, blue: 243/255, alpha: 1)
        if let decodedData = Data(base64Encoded: photo[indexPath.row], options: .ignoreUnknownCharacters) {
            cell.logo.image = UIImage(data: decodedData)
            
        }
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = certs[indexPath.row]
       
        NotifyDataChange.sharedInstance.shouldReload = true
        NotifyDataChange.sharedInstance.shouldReloadMap = true
        NotifyDataChange.sharedInstance.shouldReloadPhoto = true
        self.defaultValues.set(id, forKey: "stu_id")
        dismiss(animated: true, completion: nil)
    }
    
    
    

    

}
