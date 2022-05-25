//
//  ViewController.swift
//  ScheduleLocalNotificationsDemo
//
//  Created by Vu Thanh Nam on 17/05/2022.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var contentTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    let centerNotification = UNUserNotificationCenter.current()
    @IBAction func schedule(_ sender: UIButton) {
        print(contentTF!.text!)
        print(titleTF!.text!)
        print(datePicker!.date)
        initNotification()
    }
    
    func initNotification(){
        centerNotification.getNotificationSettings{
            (settings) in
            
            DispatchQueue.main.async {
             
            let title = self.titleTF.text!
            let body = self.contentTF.text!
            let date = self.datePicker.date
            
                
                
            if (settings.authorizationStatus == .authorized){
                //if choose ok->
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                let dateComponents = Calendar.current.dateComponents([.month,.day,.year,.hour,.minute],from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                self.centerNotification.add(request) {
                    (error) in
                    if error != nil{
                        print("Error \(error.debugDescription)")
                        return
                    }
                    
                    
                }
                let ac = UIAlertController(title: "Notification Scheduled", message: "At \(self.formattedDate(date: date))",  preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in}))
                             self.present(ac, animated: true)
            }else{
                //if choose don't allow
                let ac = UIAlertController(title: "Notification Scheduled", message: "At \(self.formattedDate(date: date))",  preferredStyle: .alert)
                let goToSetting = UIAlertAction(title: "Settings", style: .default){
                    (_) in
                    guard let settringsURL = URL(string: UIApplication.openSettingsURLString)
                    else{
                        return
                    }
                    if(UIApplication.shared.canOpenURL(settringsURL)){
                        UIApplication.shared.open(settringsURL){ (_) in}
                    }
                }
                ac.addAction(goToSetting)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in}))
                             self.present(ac, animated: true)
            }
            }
        }
        
    }
    func formattedDate(date:Date) ->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y HH:mm"
        return formatter.string(from: date)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        centerNotification.requestAuthorization(options: [.alert, . sound]){ (success,error) in
            if (!success){
                print("Permission is deny")
            }else{
                print("Successfully")
            }
        }
    }


}

