//
//  NotificationsVC.swift
//  Credit4Business
//
//  Created by MacMini on 06/05/24.
//

import UIKit

class NotificationsVC: UIViewController {
    //---------------------------------------
    // MARK: - Outlets
    //---------------------------------------
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var notificationsTable: UITableView!
    
    //MARK: -------------------- Class Variable --------------------
    var viewModel = HomeVM()
    var notificationData = [NotificationData]()
    var agentNotificationData = [AgentNotificationData]()
    var isAgent = false
    //---------------------------------------
    // MARK: - View Controller Functions
    //---------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.manageActionMethods()
        if UserDefaults.standard.value(forKey: "role") as! String == "FIELDAGENT" {
            self.isAgent = true
            self.fetchAgentNotificationsDetails()

        }else{
            self.fetchNotificationsDetails()
        }
        // Do any additional setup after loading the view.
    }
    func setDelegates() {
        self.notificationsTable.delegate = self
        self.notificationsTable.dataSource = self
        self.backBtn.isHidden = true
    }
    func manageActionMethods() {
        self.backBtn.addTapGestureRecognizer {
        
        }
    }
    func fetchAgentNotificationsDetails() {
        APIService.shared.retrieveAgentNotificationDetails() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.agentNotificationData = responseData
                       // self.agentNotificationData = self.agentNotificationData.filter({$0.isNotified == false})
                        self.notificationsTable.reloadData()
                    }
                    catch {
                        
                    }
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchNotificationsDetails() {
        APIService.shared.retrieveNotificationDetails() { result in
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    do {
                        let responseData = data.data
                        self.notificationData = responseData
                      //  self.notificationData = self.notificationData.filter({$0.isNotified == false})
                        self.notificationsTable.reloadData()
                    }
                    catch {
                        
                    }
                }
                else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    //---------------------------------------
    // MARK: - Init With Story
    //---------------------------------------

    class func initWithStory() -> NotificationsVC {
        let vc : NotificationsVC = UIStoryboard.Login.instantiateViewController()
        return vc
    }
   
}
extension NotificationsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isAgent ?  self.agentNotificationData.count : self.notificationData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == notificationsTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as? NotificationCell else {
                return UITableViewCell()
            }
            var model = self.notificationData.value(atSafe: indexPath.row)
            if isAgent {
               var model2 = self.agentNotificationData.value(atSafe: indexPath.row)
                cell.titleLabel.text = model2?.notificationType
                cell.subTitleLabel.text = model2?.message
                cell.dateLabel.text = self.convertDateFormater(date: model2?.createdOn ?? "")
                cell.blueDot.isHidden = model2?.isNotified ?? false
            }else{
                cell.titleLabel.text = model?.notificationType
                cell.subTitleLabel.text = model?.message
                cell.dateLabel.text = self.convertDateFormater(date: model?.createdOn ?? "")
                cell.blueDot.isHidden = model?.isNotified ?? false
            }
            return cell

        }

        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isAgent {
            guard let model = self.agentNotificationData.value(atSafe: indexPath.row) else {
                return
            }
            var dict2 = JSON()

            dict2["id"] = model.id ?? 0
            dict2["is_notified"] = true
            self.updateAgentNotification(params: dict2)
        }else{
            guard let model = self.notificationData.value(atSafe: indexPath.row) else {
                return
            }
            var dict2 = JSON()

            dict2["id"] = model.id ?? 0
            dict2["is_notified"] = true
            self.updateNotification(params: dict2)
        }
        
    }
    func updateAgentNotification(params: JSON) {
        APIService.shared.makeRequest(endpoint: APIEnums.retrieveAgentNotificationDetails.rawValue,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.fetchAgentNotificationsDetails()
                }
                else if data.statusCode == 401 {
                    self.tokenRefreshApi(params: params)
                }
                else {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }

            case .failure(let error):
                print(error)
                self.showAlert(title: "Info", message: error.localizedDescription)
            }
        }
    }
    func updateNotification(params: JSON) {
        APIService.shared.makeRequest(endpoint: APIEnums.retrieveNotificationDetails.rawValue,
                                      withLoader: true,
                                      method: .post,
                                      params: params) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    self.fetchNotificationsDetails()
                }
                else if data.statusCode == 401 {
                    self.tokenRefreshApi(params: params)
                }
                else {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }

            case .failure(let error):
                print(error)
                self.showAlert(title: "Info", message: error.localizedDescription)
            }
        }
    }
    func tokenRefreshApi(params: JSON) {
        var dict = JSON()
        dict["refresh"] = UserDefaults.standard.value(forKey: "refresh") as? String
        APIService.shared.refreshTokenRequest(endpoint: APIEnums.refreshToken.rawValue,
                                      withLoader: true,
                                      method: .post,
                                      params: dict) { result in
            
            switch result {
            case .success(let data):
                if data.statusCode == 200 {
                    UserDefaults.standard.set(data.access, forKey:"access")
                    UserDefaults.standard.set(data.refresh, forKey:"refresh")

                    if self.isAgent{
                        self.updateAgentNotification(params: params)
                    }else{
                        self.updateNotification(params: params)
                    }
                }
                else {
                    self.showAlert(title: "Info", message: data.statusMessage)
                }

            case .failure(let error):
                print(error)
                self.showAlert(title: "Info", message: error.localizedDescription)
            }
        }

    }
}
