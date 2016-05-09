//
//  TableManagerClass.swift
//  TipNTop
//
//  Created by Sadhana Maniarasu on 4/2/16.
//  Copyright © 2016 Sadhana Maniarasu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class TableManagerClass {
    
    class var sharedInstance: TableManagerClass {
        
        struct Static {
            static let instance: TableManagerClass = TableManagerClass()
        }
        return Static.instance
    }
    
    public var tables = [Table]()
    var tableView = [UIView]()
    var timerButton = [UIButton]()
    var tableAmount = [UILabel]()
    var timerDisplay = [UILabel]()
    var playerName = [UITextField]()
    var phoneNo = [UITextField]()
    var tag = 0
    var batchno = 0
  
}

public class Table {
    var updateTimeFn : String = ""
    var isrunning : Bool = false
    var boardcost : Float = 0.0
    var timeris_on : Bool = false
    var done : Bool = false
    var hasPaid : Bool = false
    var startTime = NSTimeInterval()
    var elapsedTime = NSTimeInterval()
    var pausedTime = NSTimeInterval()
    var resumedTime = NSTimeInterval()
    var totalPausedInterval = NSTimeInterval()
    var ispaused = false
    var totalCost = Float()
   // var AddonCost = Float(0.0)
    var minimumcost = Float(50)
    var paid = Float()
    var BillSummary: NSString = ""
    var hour = Int(0)
    var minutes = Int(0)
    var seconds = Int(0)
    var timer = NSTimer()
    /* TO TAKE CARE*/
    var waspaused = false
    var discount = Float(0.0)
    var startTimeString = ""
    var endTimeString = ""
    var duration = ""
    var batchno = 0
    var cost = Float(2.5)
    var playername = ""
    var addons = [Addon]()
    var addonstring = ""
    var canteenCost = Float(0.0)
    var otherCost = Float(0.0)
    var phoneno = ""
    var ipaddress = ""
        init (updateFn: String) {
        updateTimeFn = updateFn
        
    }
    
    func refresh () {
         updateTimeFn = ""
         isrunning = false
         boardcost = 0.0
         timeris_on = false
         done = false
         hasPaid  = false
         startTime = NSTimeInterval()
         elapsedTime = NSTimeInterval()
         pausedTime = NSTimeInterval()
         resumedTime = NSTimeInterval()
         totalPausedInterval = NSTimeInterval()
         ispaused = false
         totalCost = Float()
        // var AddonCost = Float(0.0)
         minimumcost = Float(50)
         paid = Float()
         BillSummary = ""
         hour = Int(0)
         minutes = Int(0)
         seconds = Int(0)
         timer = NSTimer()
        /* TO TAKE CARE*/
         waspaused = false
         discount = Float(0.0)
         startTimeString = ""
         endTimeString = ""
         duration = ""
         batchno = 0
         cost = Float(2.5)
         playername = ""
         addons = [Addon]()
         addonstring = ""
         canteenCost = Float(0.0)
         otherCost = Float(0.0)
         phoneno = ""
         ipaddress = ""
    }
}

public class Addon {
    var description : String = ""
    var cost : Float = 0.0
    
    init (descript: String, value: Float) {
        description = descript
        cost = value
    }
}
class TableManager: UIViewController , UIWebViewDelegate{
    
    @IBOutlet weak var myWebView: UIWebView!
    
    
    @IBOutlet weak var tableView1: UIView!
    
    @IBOutlet weak var timerButton1: UIButton!
    
    @IBOutlet weak var tableAmount1: UILabel!
    
    @IBOutlet weak var timerDisplay1: UILabel!
    
    @IBOutlet weak var playerName1: UITextField!
    
    @IBOutlet weak var phoneNo1: UITextField!
    @IBOutlet weak var phoneNo2: UITextField!
    @IBOutlet weak var phoneNo3: UITextField!
    @IBOutlet weak var phoneNo4: UITextField!
    
    
    
    func checkandsendupdate() {
        let date = NSDate()
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: date)
        
        if components.day == 1 {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            let fetchRequest = NSFetchRequest(entityName: "ChargeSheet")
            var updated =  [NSManagedObject]()
            //3
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                updated = results as! [NSManagedObject]
               
                if updated.count != 0  {
                    
                     if (!(updated[0].valueForKey("updateSent") as! Bool)) {
                    sendMonthlyupdate()
                        
                    }
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            
        } else if components.day == 2 {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            let fetchRequest = NSFetchRequest(entityName: "ChargeSheet")
            var updated =  [NSManagedObject]()
            //3
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                updated = results as! [NSManagedObject]
                
                if updated.count != 0  {
                    if (!(updated[0].valueForKey("updateSent") as! Bool)) {
                        sendMonthlyupdate()
                    } else {
                        updated[0].setValue(false, forKey: "updateSent")
                    }
                    do {
                        try managedContext.save()
                        //5
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }

    }
    }
    override func viewDidLoad() {
        if TableManagerClass.sharedInstance.tables.count == 0 {
            TableManagerClass.sharedInstance.tables.append(Table(updateFn: "timerUpdate1"))
            TableManagerClass.sharedInstance.tables.append(Table(updateFn: "timerUpdate2"))
            TableManagerClass.sharedInstance.tables.append(Table(updateFn: "timerUpdate3"))
            TableManagerClass.sharedInstance.tables.append(Table(updateFn: "timerUpdate4"))
            
            
           

            
        }
       
        txtView.hidden = true
        myWebView.hidden = true
        createArrays()
        
        checkandsendupdate()
        
        
        
      /*  let query = PFQuery(className:"BoardCost")
        
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error == nil {
                
                var boarcosts = NSArray()
                
                
                if results?.count != 0 {
                    boarcosts = NSArray(array: results!)
                    print("\(boarcosts)")
                    for (var i = 0 ; i < boarcosts.count ; i = i+1) {
                    let board_cost = boarcosts[i] as! PFObject
                    
                    let tableno = (board_cost.valueForKey("tableNo") as! NSString).integerValue
                        
                    TableManagerClass.sharedInstance.tables[tableno - 1].minimumcost = (board_cost.valueForKey("cost") as! NSNumber).floatValue
                    }
                } else {
                    
                }
            }
        }*/
        
        let query2 = PFQuery(className:"ipAddress")
        
        query2.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error == nil {
                
                var ipAddresses = NSArray()
                
                
                if results?.count != 0 {
                    ipAddresses = NSArray(array: results!)
                    
                    for (var i = 0 ; i < ipAddresses.count ; i = i+1) {
                        let ipaddress = ipAddresses[i] as! PFObject
                        
                        let tableno = (ipaddress.valueForKey("tableNo") as! NSString).integerValue
                        
                        TableManagerClass.sharedInstance.tables[tableno - 1].ipaddress = (ipaddress.valueForKey("ipaddress") as! String)
                    }
                } else {
                    
                }
            }
        }

        
    }
    
    func createArrays() {
        TableManagerClass.sharedInstance.tableView.insert(tableView1, atIndex: 0)
        TableManagerClass.sharedInstance.tableView.insert(tableView2, atIndex: 1)
        TableManagerClass.sharedInstance.tableView.insert(tableView3, atIndex: 2)
        TableManagerClass.sharedInstance.tableView.insert(tableView4, atIndex: 3)
        
        TableManagerClass.sharedInstance.timerButton.insert(timerButton1, atIndex: 0)
        TableManagerClass.sharedInstance.timerButton.insert(timerButton2, atIndex: 1)
        TableManagerClass.sharedInstance.timerButton.insert(timerButton3, atIndex: 2)
        TableManagerClass.sharedInstance.timerButton.insert(timerButton4, atIndex: 3)
        
        TableManagerClass.sharedInstance.tableAmount.insert(tableAmount1, atIndex: 0)
        TableManagerClass.sharedInstance.tableAmount.insert(tableAmount2, atIndex: 1)
        TableManagerClass.sharedInstance.tableAmount.insert(tableAmount3, atIndex: 2)
        TableManagerClass.sharedInstance.tableAmount.insert(tableAmount4, atIndex: 3)

        TableManagerClass.sharedInstance.timerDisplay.insert(timerDisplay1, atIndex: 0)
        TableManagerClass.sharedInstance.timerDisplay.insert(timerDisplay2, atIndex: 1)
        TableManagerClass.sharedInstance.timerDisplay.insert(timerDisplay3, atIndex: 2)
        TableManagerClass.sharedInstance.timerDisplay.insert(timerDisplay4, atIndex: 3)
        
        TableManagerClass.sharedInstance.playerName.insert(playerName1, atIndex: 0)
        TableManagerClass.sharedInstance.playerName.insert(playerName2, atIndex: 1)
        TableManagerClass.sharedInstance.playerName.insert(playerName3, atIndex: 2)
        TableManagerClass.sharedInstance.playerName.insert(playerName4, atIndex: 3)

        TableManagerClass.sharedInstance.phoneNo.insert(phoneNo1, atIndex: 0)
        TableManagerClass.sharedInstance.phoneNo.insert(phoneNo2, atIndex: 1)
        TableManagerClass.sharedInstance.phoneNo.insert(phoneNo3, atIndex: 2)
        TableManagerClass.sharedInstance.phoneNo.insert(phoneNo4, atIndex: 3)
 
    }
    
    @IBAction func timerAction1(sender: AnyObject) {
        
        let dateFormater = NSDateFormatter()
        
        
        dateFormater.timeZone = NSTimeZone()
        dateFormater.dateFormat = "dd/MM/yyyy hh:mm:ss a"
        if TableManagerClass.sharedInstance.tables[sender.tag].timeris_on == false && TableManagerClass.sharedInstance.tables[sender.tag].ispaused == false{
            
            let alert1 = UIAlertController(title: "Start timer ?" as String,
                                           message: " ",
                                           preferredStyle: .Alert)
            
            let startAction = UIAlertAction(title: "Start",
                                            style: .Default) { (action: UIAlertAction!) -> Void in
                                                
                                                TableManagerClass.sharedInstance.tables[sender.tag].refresh()
                                                
                                                TableManagerClass.sharedInstance.tables[sender.tag].timeris_on = true
                                                TableManagerClass.sharedInstance.tables[sender.tag].done = false
                                                TableManagerClass.sharedInstance.tables[sender.tag].hasPaid = false
                                                TableManagerClass.sharedInstance.tables[sender.tag].totalCost = 0
                                                TableManagerClass.sharedInstance.tables[sender.tag].boardcost = 0
                                                
                                                
                                                TableManagerClass.sharedInstance.tables[sender.tag].ispaused = false
                                                TableManagerClass.sharedInstance.tables[sender.tag].isrunning = true
                                                TableManagerClass.sharedInstance.tables[sender.tag].startTime = NSDate.timeIntervalSinceReferenceDate()
                                                TableManagerClass.sharedInstance.tables[sender.tag].startTimeString = "\(dateFormater.stringFromDate(NSDate()))"
                                                
                                                
                                                
                                                
                                                
                                                let image = UIImage(named: "stopbutton.png") as UIImage?
                                                sender.setBackgroundImage(image, forState: UIControlState.Normal)
                                                var aselector = Selector()
                                                
                                                switch sender.tag {
                                                case 0 :
                                                    self.tableAmount1.text = "50.00"
                                                    aselector = Selector("updateTime1")
                                                    TableManagerClass.sharedInstance.tag = 0
                                                    break;
                                                    
                                                case 1:
                                                    self.tableAmount2.text = "50.00"
                                                    aselector = "updateTime2"
                                                    TableManagerClass.sharedInstance.tag = 1
                                                    break;
                                                    
                                                case 2:
                                                    self.tableAmount3.text  = "50.00"
                                                    aselector = "updateTime3"
                                                    TableManagerClass.sharedInstance.tag = 2
                                                    break;
                                                    
                                                case 3 :
                                                    self.tableAmount4.text = "50.00"
                                                    aselector = "updateTime4"
                                                    TableManagerClass.sharedInstance.tag = 3
                                                    break
                                                    
                                                default:
                                                    break
                                                    
                                                    
                                                }
                                                
                                                
                                                
                                               
                                                
                                                TableManagerClass.sharedInstance.tables[sender.tag].timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: aselector, userInfo: nil, repeats: true)
                    TableManagerClass.sharedInstance.tables[sender.tag].batchno = self.getbatchno()
                   // TableManagerClass.sharedInstance.batchno = TableManagerClass.sharedInstance.tables[sender.tag].batchno + 1
                    self.updateBatchno(TableManagerClass.sharedInstance.tables[sender.tag].batchno + 1)
                                                
                                                
                                            /*    let pushQuery = PFInstallation.query()
                                                pushQuery?.whereKey("deviceType", equalTo: "ios")
                                                
                                                // Send push notification to query
                                                let push = PFPush()
                                                push.setQuery(pushQuery)
                                                push.setMessage("Started playing in Table\(sender.tag + 1) at \(TableManagerClass.sharedInstance.tables[sender.tag].startTimeString)");
                                                push.sendPushInBackground()
*/
                                                self.sendEmail("Batch No \(TableManagerClass.sharedInstance.tables[sender.tag].batchno) : Started playing in Table\(sender.tag + 1) at \(TableManagerClass.sharedInstance.tables[sender.tag].startTimeString)",body: "",attachment: false, delete: false,filepath: "")
                                                
                                                let url = NSURL (string: TableManagerClass.sharedInstance.tables[sender.tag].ipaddress);
                                                let requestObj = NSURLRequest(URL: url!);
                                                self.myWebView.loadRequest(requestObj);                                                alert1.dismissViewControllerAnimated(true, completion: nil)
                                                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .Default) { (action: UIAlertAction!) -> Void in
                                                alert1.dismissViewControllerAnimated(true, completion: nil)
                                                
            }
            
            alert1.addAction(startAction)
            alert1.addAction(cancelAction)
            
            
            self.presentViewController(alert1,
                                       animated: true,
                                       completion: nil)
            
            
            
        } else {
            
              if TableManagerClass.sharedInstance.tables[sender.tag].timeris_on == false && TableManagerClass.sharedInstance.tables[sender.tag].ispaused == true {
                
                
                let alert3 = UIAlertController(title: "Resume table??" as String,
                                               message: " ",
                                               preferredStyle: .Alert)
                let cancelResumeAction = UIAlertAction(title: "Cancel",
                                                 style: .Default) { (action: UIAlertAction!) -> Void in
                                                    alert3.dismissViewControllerAnimated(true, completion: nil)
                                                    
                }
                
                let ResumeAction = UIAlertAction(title: "Ok",
                                                 style: .Default) { (action: UIAlertAction!) -> Void in
                
                TableManagerClass.sharedInstance.tables[sender.tag].ispaused = false
                TableManagerClass.sharedInstance.tables[sender.tag].timeris_on = true
                TableManagerClass.sharedInstance.tables[sender.tag].resumedTime = NSDate.timeIntervalSinceReferenceDate()
                TableManagerClass.sharedInstance.tables[sender.tag].waspaused = true
                
                let image = UIImage(named: "stopbutton.png") as UIImage?
                TableManagerClass.sharedInstance.timerButton[sender.tag].setBackgroundImage(image, forState: UIControlState.Normal)
                //   sender.setTitle("Pause", forState: UIControlState.Normal)
                var aselector = Selector()
                
                switch sender.tag {
                case 0 :
                    aselector = Selector("updateTime1")
                    TableManagerClass.sharedInstance.tag = 0
                    break;
                    
                case 1:
                    aselector = Selector("updateTime2")
                    TableManagerClass.sharedInstance.tag = 1
                    break;
                    
                case 2:
                    aselector = Selector("updateTime3")
                    TableManagerClass.sharedInstance.tag = 2
                    break;
                    
                case 3 :
                    aselector = Selector("updateTime4")
                    TableManagerClass.sharedInstance.tag = 3
                    break
                    
                default:
                    break
                    
                    
                }
                
                
                let url = NSURL (string: TableManagerClass.sharedInstance.tables[sender.tag].ipaddress);
                let requestObj = NSURLRequest(URL: url!);
                self.myWebView.loadRequest(requestObj);
                
                                                    self.sendEmail("Batch No \(TableManagerClass.sharedInstance.tables[sender.tag].batchno): Resumed playing in table \(sender.tag + 1)", body: "",attachment: false,delete: false,filepath: "")
                
                TableManagerClass.sharedInstance.tables[sender.tag].timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: aselector, userInfo: nil, repeats: true)
                }
                alert3.addAction(ResumeAction)
                alert3.addAction(cancelResumeAction)
                
                
                self.presentViewController(alert3,
                                           animated: true,
                                           completion: nil)
                

              } else {

            
            let alert1 = UIAlertController(title: "Choose action" as String,
                                           message: " ",
                                        preferredStyle: .Alert)
                
              let alert2 = UIAlertController(title: "" as String, message: " ",
                    preferredStyle: .Alert)
                
                let applyDiscountAction =  UIAlertAction(title: "Apply Discount",
                                                         style: .Default) { (action: UIAlertAction!) -> Void in
                    if (alert2.textFields![0].text! != "") {
                    TableManagerClass.sharedInstance.tables[sender.tag].discount = (alert2.textFields![0].text! as NSString).floatValue
                    }
                    
                    TableManagerClass.sharedInstance.tables[sender.tag].boardcost -= ((TableManagerClass.sharedInstance.tables[sender.tag].boardcost * TableManagerClass.sharedInstance.tables[sender.tag].discount) / 100)
                    TableManagerClass.sharedInstance.tables[sender.tag].totalCost = TableManagerClass.sharedInstance.tables[sender.tag].boardcost + TableManagerClass.sharedInstance.tables[sender.tag].otherCost + TableManagerClass.sharedInstance.tables[sender.tag].canteenCost
                    
                    
                    alert2.title = "Bill Summary\n==============\nDuration: \(TableManagerClass.sharedInstance.tables[sender.tag].duration)\nBoard Cost: Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].boardcost)\nCanteen: Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].canteenCost)\nOther: Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].otherCost)\nDiscount: \(TableManagerClass.sharedInstance.tables[sender.tag].discount)%\nTotal: Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].totalCost) "
                                                            
                    alert2.dismissViewControllerAnimated(true, completion: nil)
                                                            
                    self.presentViewController(alert2,animated: true,completion: nil)

                                                            
                }
                
                let paidAction =  UIAlertAction(title: "Paid",style: .Default) { (action: UIAlertAction!) -> Void in
                    
                                       let pushQuery = PFInstallation.query()
                    pushQuery?.whereKey("deviceType", equalTo: "ios")
                    
                    // Send push notification to query
                   /* let push = PFPush()
                    push.setQuery(pushQuery)
                    push.setMessage("Stopped playing in Table\(sender.tag + 1) at \(TableManagerClass.sharedInstance.tables[sender.tag].endTimeString)");
                    push.sendPushInBackground()
                    */
                  //  let record = PFObject(className: "Records")
 
                    
                    
                  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    let managedContext = appDelegate.managedObjectContext
                                                            
                                                            //2
                    let entity =  NSEntityDescription.entityForName("Records",inManagedObjectContext:managedContext)
                                                            
                    let record = NSManagedObject(entity: entity!,insertIntoManagedObjectContext: managedContext)
                                                            
                                                            //3*/
                    record.setValue(TableManagerClass.sharedInstance.tables[sender.tag].playername, forKey: "name")
                    record.setValue(TableManagerClass.sharedInstance.tables[sender.tag].phoneno, forKey: "phoneno")
                    record.setValue(TableManagerClass.sharedInstance.tables[sender.tag].startTimeString, forKey: "startTime")
                    record.setValue(TableManagerClass.sharedInstance.tables[sender.tag].endTimeString, forKey: "endTime")
                    record.setValue(TableManagerClass.sharedInstance.tables[sender.tag].duration, forKey: "duration")
                    
                    // Calculate minutes in elapsed time
                    let hour  = Int(TableManagerClass.sharedInstance.tables[sender.tag].totalPausedInterval/3600.0)
                    TableManagerClass.sharedInstance.tables[sender.tag].totalPausedInterval -= (NSTimeInterval(hour)*3600)
                    let minutes = Int(TableManagerClass.sharedInstance.tables[sender.tag].elapsedTime/60.0)
                    
                    TableManagerClass.sharedInstance.tables[sender.tag].totalPausedInterval -= (NSTimeInterval(minutes)*60)
                    
                    let seconds = Int(TableManagerClass.sharedInstance.tables[sender.tag].totalPausedInterval)
                    TableManagerClass.sharedInstance.tables[sender.tag].totalPausedInterval -= NSTimeInterval(seconds)
                    
                    let pausedIntervaltext = NSString(format: "%02u:%02u:%02u", hour,minutes,seconds) as String
                    
                    record.setValue(pausedIntervaltext, forKey: "pausedTime")
                     record.setValue(TableManagerClass.sharedInstance.tables[sender.tag].boardcost, forKey: "boardBill")
                    
                    record.setValue(TableManagerClass.sharedInstance.tables[sender.tag].canteenCost, forKey: "canteenCost")
                    record.setValue(TableManagerClass.sharedInstance.tables[sender.tag].otherCost, forKey: "otherCost")
                    record.setValue(TableManagerClass.sharedInstance.tables[sender.tag].addonstring, forKey: "addonDetail")
                   
                    record.setValue("\(TableManagerClass.sharedInstance.tables[sender.tag].discount)", forKey: "discount")
                    
                    record.setValue(TableManagerClass.sharedInstance.tables[sender.tag].totalCost, forKey: "totalBill")
                    
                    record.setValue(TableManagerClass.sharedInstance.tables[sender.tag].batchno, forKey: "batchno")
                    
                    record.setValue((sender.tag + 1), forKey: "tableno")
                    
                  //  record.saveInBackground()
                                                            //4
                    do {
                        try managedContext.save()
                                                                //5
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                    self.updateCharges(TableManagerClass.sharedInstance.tables[sender.tag].boardcost, canteencost: TableManagerClass.sharedInstance.tables[sender.tag].canteenCost, othercost: TableManagerClass.sharedInstance.tables[sender.tag].otherCost, totalcost: TableManagerClass.sharedInstance.tables[sender.tag].totalCost)
                    
                    
                    //2
                    self.sendEmail("Batch No \(TableManagerClass.sharedInstance.tables[sender.tag].batchno): Stopped playing in Table\(sender.tag + 1) at \(TableManagerClass.sharedInstance.tables[sender.tag].endTimeString)", body: "Bill Summary :\nPlayer Name:\(TableManagerClass.sharedInstance.tables[sender.tag].playername) \nDuration: \(TableManagerClass.sharedInstance.tables[sender.tag].duration)\nBoard Cost: Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].boardcost)\nCanteen: Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].canteenCost)\nOther: Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].otherCost)\nDiscount: \(TableManagerClass.sharedInstance.tables[sender.tag].discount)%\nTotal: Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].totalCost) ",attachment: false,delete: false,filepath: "")
                   
                    
                    alert1.dismissViewControllerAnimated(true, completion: nil)
                    
                    self.printBill("Tip N Top\n\nBill Summary \n======================\nPlayer Name    : \(TableManagerClass.sharedInstance.tables[sender.tag].playername) \nTable No         : \(sender.tag + 1)\nDuration        : \(TableManagerClass.sharedInstance.tables[sender.tag].duration)\nBoard Cost    : Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].boardcost)\nCanteen Cost  : Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].canteenCost)\nOther Cost    : Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].otherCost)\nDiscount       : \(TableManagerClass.sharedInstance.tables[sender.tag].discount)%\n=======================\nTotal           : Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].totalCost)\n=======================\n")
                    
                    self.cleartable(sender.tag)
                }
                
                
                alert2.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                    textField.placeholder = "Discount"
                })
                
                alert2.addAction(applyDiscountAction)
                alert2.addAction(paidAction)

            let stopAction = UIAlertAction(title: "Stop",
                                           style: .Default) { (action: UIAlertAction!) -> Void in
                                            if (TableManagerClass.sharedInstance.tables[sender.tag].playername == "" ||
                                                TableManagerClass.sharedInstance.tables[sender.tag].phoneno  ==  "" ){
                                                self.popupAlert("Please enter name and mobile number")
                                                return
                                            }

                                            TableManagerClass.sharedInstance.tables[sender.tag].endTimeString = "\(dateFormater.stringFromDate(NSDate()))"
                                            
                                            TableManagerClass.sharedInstance.tables[sender.tag].timeris_on = false
                                            TableManagerClass.sharedInstance.tables[sender.tag].endTimeString = "\(dateFormater.stringFromDate(NSDate()))"
                                            TableManagerClass.sharedInstance.tables[sender.tag].ispaused = false
                                            TableManagerClass.sharedInstance.tables[sender.tag].isrunning = false
                                            TableManagerClass.sharedInstance.tables[sender.tag].elapsedTime = 0
                                            TableManagerClass.sharedInstance.tables[sender.tag].timer.invalidate()
                                            let image = UIImage(named: "buttonstart.png") as UIImage?
                                            sender.setBackgroundImage(image, forState: UIControlState.Normal)
                                            
                                            TableManagerClass.sharedInstance.tables[sender.tag].totalCost = TableManagerClass.sharedInstance.tables[sender.tag].boardcost + TableManagerClass.sharedInstance.tables[sender.tag].canteenCost + TableManagerClass.sharedInstance.tables[sender.tag].otherCost
                                           
                                            TableManagerClass.sharedInstance.tables[sender.tag].duration = TableManagerClass.sharedInstance.timerDisplay[sender.tag].text!
                                            
                                            
                                            alert1.dismissViewControllerAnimated(true, completion: nil)
                                            
                                            alert2.title = "Bill Summary\n==============\nDuration: \(TableManagerClass.sharedInstance.tables[sender.tag].duration)\nBoard Cost: Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].boardcost)\nCanteen: Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].canteenCost)\nOther: Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].otherCost)\nDiscount: \(TableManagerClass.sharedInstance.tables[sender.tag].discount)%\nTotal: Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].totalCost) "
                                            
                                            self.presentViewController(alert2,
                                                                       animated: true,
                                                                       completion: nil)
                                            let url = NSURL (string: TableManagerClass.sharedInstance.tables[sender.tag].ipaddress);
                                            let requestObj = NSURLRequest(URL: url!);
                                            self.myWebView.loadRequest(requestObj);
                                            

                                            
                }

                                            
            
            
            let pauseAction = UIAlertAction(title: "Pause",
                                           style: .Default) { (action: UIAlertAction!) -> Void in
                                           
                                            if TableManagerClass.sharedInstance.tables[sender.tag].isrunning == true {
                                                
                                                if TableManagerClass.sharedInstance.tables[sender.tag].timeris_on == true &&  TableManagerClass.sharedInstance.tables[sender.tag].ispaused == false{
                                                    
                                                    TableManagerClass.sharedInstance.tables[sender.tag].ispaused = true
                                                    TableManagerClass.sharedInstance.tables[sender.tag].timeris_on = false
                                                    TableManagerClass.sharedInstance.tables[sender.tag].waspaused = false
                                                    TableManagerClass.sharedInstance.tables[sender.tag].pausedTime = NSDate.timeIntervalSinceReferenceDate()
                                                    
                                                    let image = UIImage(named: "pausebutton.png") as UIImage?
                                                    TableManagerClass.sharedInstance.timerButton[sender.tag].setBackgroundImage(image, forState: UIControlState.Normal)
                                                    //sender.setTitle("Resume", forState: UIControlState.Normal)
                                                    
                                                    TableManagerClass.sharedInstance.tables[sender.tag].timer.invalidate()
                                                    
                                                    self.sendEmail("Batch No \(TableManagerClass.sharedInstance.tables[sender.tag].batchno): Paused playing in Table\(sender.tag + 1)", body: "",attachment: false,delete: false,filepath: "")
                                                }
                                                
                                            }

                                         /*   let pushQuery = PFInstallation.query()
                                            pushQuery?.whereKey("deviceType", equalTo: "ios")
                                            
                                            // Send push notification to query
                                            let push = PFPush()
                                            push.setQuery(pushQuery)
                                            push.setMessage("Paused playing in Table\(sender.tag + 1))");
                                            push.sendPushInBackground()
                                            */
                                            
                                           
                                            let url = NSURL (string: TableManagerClass.sharedInstance.tables[sender.tag].ipaddress);
                                            let requestObj = NSURLRequest(URL: url!);
                                            self.myWebView.loadRequest(requestObj);
                                            

                                            alert1.dismissViewControllerAnimated(true, completion: nil)
                                            
            }

            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .Default) { (action: UIAlertAction!) -> Void in
                                                alert1.dismissViewControllerAnimated(true, completion: nil)
                                                
            }
            
            alert1.addAction(stopAction)
            alert1.addAction(pauseAction)
            alert1.addAction(cancelAction)
            
            
            self.presentViewController(alert1,
                                       animated: true,
                                       completion: nil)
            
            }
            
            
        }

        
                 /*  WOrking
         http://stackoverflow.com/questions/32593516/how-do-i-exactly-export-a-csv-file-from-ios-written-in-swift
        */
        

    }
    
    
    func updateTime1(){
        
        
        if ( TableManagerClass.sharedInstance.tables[0].timeris_on == false || TableManagerClass.sharedInstance.tables[0].ispaused == true){
            return
        }
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        
        // Find difference between current time and start time
        if TableManagerClass.sharedInstance.tables[0].waspaused == true {
            let temp = TableManagerClass.sharedInstance.tables[0].resumedTime - TableManagerClass.sharedInstance.tables[0].pausedTime
            
            TableManagerClass.sharedInstance.tables[0].totalPausedInterval = TableManagerClass.sharedInstance.tables[0].totalPausedInterval + temp
            TableManagerClass.sharedInstance.tables[0].pausedTime = 0
            TableManagerClass.sharedInstance.tables[0].resumedTime = 0
            TableManagerClass.sharedInstance.tables[0].waspaused = false
            
        }
        
        TableManagerClass.sharedInstance.tables[0].elapsedTime = currentTime - TableManagerClass.sharedInstance.tables[0].startTime
        
        TableManagerClass.sharedInstance.tables[0].elapsedTime = TableManagerClass.sharedInstance.tables[0].elapsedTime - TableManagerClass.sharedInstance.tables[0].totalPausedInterval
        

        // Calculate minutes in elapsed time
        TableManagerClass.sharedInstance.tables[0].hour  = Int(TableManagerClass.sharedInstance.tables[0].elapsedTime/3600.0)
        TableManagerClass.sharedInstance.tables[0].elapsedTime -= (NSTimeInterval(TableManagerClass.sharedInstance.tables[0].hour)*3600)
        TableManagerClass.sharedInstance.tables[0].minutes = Int(TableManagerClass.sharedInstance.tables[0].elapsedTime/60.0)
        
        TableManagerClass.sharedInstance.tables[0].elapsedTime -= (NSTimeInterval(TableManagerClass.sharedInstance.tables[0].minutes)*60)
        
        TableManagerClass.sharedInstance.tables[0].seconds = Int(TableManagerClass.sharedInstance.tables[0].elapsedTime)
        TableManagerClass.sharedInstance.tables[0].elapsedTime -= NSTimeInterval(TableManagerClass.sharedInstance.tables[0].seconds)
        
        TableManagerClass.sharedInstance.timerDisplay[0].text = NSString(format: "%02u:%02u:%02u", TableManagerClass.sharedInstance.tables[0].hour,TableManagerClass.sharedInstance.tables[0].minutes,TableManagerClass.sharedInstance.tables[0].seconds) as String
        if( (TableManagerClass.sharedInstance.tables[0].minutes + (TableManagerClass.sharedInstance.tables[0].hour * 60 )) <= 20){
            TableManagerClass.sharedInstance.tables[0].boardcost =  TableManagerClass.sharedInstance.tables[0].minimumcost
        } else {
            TableManagerClass.sharedInstance.tables[0].boardcost = (NSNumber(integer: TableManagerClass.sharedInstance.tables[0].hour).floatValue * 60 * TableManagerClass.sharedInstance.tables[0].cost)+(NSNumber(integer: TableManagerClass.sharedInstance.tables[0].minutes).floatValue
                * TableManagerClass.sharedInstance.tables[0].cost)
            
}
      
        TableManagerClass.sharedInstance.tableAmount[0].text = NSString(format: "%.2f", TableManagerClass.sharedInstance.tables[0].boardcost) as String
        
    }
    
    func updateTime2(){
        
        
        if ( TableManagerClass.sharedInstance.tables[1].timeris_on == false || TableManagerClass.sharedInstance.tables[1].ispaused == true){
            return
        }
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        
        // Find difference between current time and start time
        if TableManagerClass.sharedInstance.tables[1].waspaused == true {
            let temp = TableManagerClass.sharedInstance.tables[1].resumedTime - TableManagerClass.sharedInstance.tables[1].pausedTime
            
            TableManagerClass.sharedInstance.tables[1].totalPausedInterval = TableManagerClass.sharedInstance.tables[1].totalPausedInterval + temp
            TableManagerClass.sharedInstance.tables[1].pausedTime = 0
            TableManagerClass.sharedInstance.tables[1].resumedTime = 0
            TableManagerClass.sharedInstance.tables[1].waspaused = false
            
        }
        
        TableManagerClass.sharedInstance.tables[1].elapsedTime = currentTime - TableManagerClass.sharedInstance.tables[1].startTime
        
        TableManagerClass.sharedInstance.tables[1].elapsedTime = TableManagerClass.sharedInstance.tables[1].elapsedTime - TableManagerClass.sharedInstance.tables[1].totalPausedInterval
        
      
        // Calculate minutes in elapsed time
        TableManagerClass.sharedInstance.tables[1].hour  = Int(TableManagerClass.sharedInstance.tables[1].elapsedTime/3600.0)
        TableManagerClass.sharedInstance.tables[1].elapsedTime -= (NSTimeInterval(TableManagerClass.sharedInstance.tables[1].hour)*3600)
        TableManagerClass.sharedInstance.tables[1].minutes = Int(TableManagerClass.sharedInstance.tables[1].elapsedTime/60.0)
        
        TableManagerClass.sharedInstance.tables[1].elapsedTime -= (NSTimeInterval(TableManagerClass.sharedInstance.tables[1].minutes)*60)
        
        TableManagerClass.sharedInstance.tables[1].seconds = Int(TableManagerClass.sharedInstance.tables[1].elapsedTime)
        TableManagerClass.sharedInstance.tables[1].elapsedTime -= NSTimeInterval(TableManagerClass.sharedInstance.tables[1].seconds)
        
        TableManagerClass.sharedInstance.timerDisplay[1].text = NSString(format: "%02u:%02u:%02u", TableManagerClass.sharedInstance.tables[1].hour,TableManagerClass.sharedInstance.tables[1].minutes,TableManagerClass.sharedInstance.tables[1].seconds) as String
        if( (TableManagerClass.sharedInstance.tables[1].minutes + (TableManagerClass.sharedInstance.tables[1].hour * 60 )) <= 20){
            TableManagerClass.sharedInstance.tables[1].boardcost =  TableManagerClass.sharedInstance.tables[1].minimumcost
        } else {
            TableManagerClass.sharedInstance.tables[1].boardcost = (NSNumber(integer: TableManagerClass.sharedInstance.tables[1].hour).floatValue * 60 * TableManagerClass.sharedInstance.tables[1].cost)+(NSNumber(integer: TableManagerClass.sharedInstance.tables[1].minutes).floatValue
                * TableManagerClass.sharedInstance.tables[1].cost)
        }
        
        TableManagerClass.sharedInstance.tableAmount[1].text = NSString(format: "%.2f", TableManagerClass.sharedInstance.tables[1].boardcost) as String
        
        
    }

    func updateTime3(){
        
        
        if ( TableManagerClass.sharedInstance.tables[2].timeris_on == false || TableManagerClass.sharedInstance.tables[2].ispaused == true){
            return
        }
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        
        // Find difference between current time and start time
        if TableManagerClass.sharedInstance.tables[2].waspaused == true {
            let temp = TableManagerClass.sharedInstance.tables[2].resumedTime - TableManagerClass.sharedInstance.tables[2].pausedTime
            
            TableManagerClass.sharedInstance.tables[2].totalPausedInterval = TableManagerClass.sharedInstance.tables[2].totalPausedInterval + temp
            TableManagerClass.sharedInstance.tables[2].pausedTime = 0
            TableManagerClass.sharedInstance.tables[2].resumedTime = 0
            TableManagerClass.sharedInstance.tables[2].waspaused = false
            
        }
        
        TableManagerClass.sharedInstance.tables[2].elapsedTime = currentTime - TableManagerClass.sharedInstance.tables[2].startTime
        
        TableManagerClass.sharedInstance.tables[2].elapsedTime = TableManagerClass.sharedInstance.tables[2].elapsedTime - TableManagerClass.sharedInstance.tables[2].totalPausedInterval
        
        
        // Calculate minutes in elapsed time
        TableManagerClass.sharedInstance.tables[2].hour  = Int(TableManagerClass.sharedInstance.tables[2].elapsedTime/3600.0)
        TableManagerClass.sharedInstance.tables[2].elapsedTime -= (NSTimeInterval(TableManagerClass.sharedInstance.tables[2].hour)*3600)
        TableManagerClass.sharedInstance.tables[2].minutes = Int(TableManagerClass.sharedInstance.tables[2].elapsedTime/60.0)
        
        TableManagerClass.sharedInstance.tables[2].elapsedTime -= (NSTimeInterval(TableManagerClass.sharedInstance.tables[2].minutes)*60)
        
        TableManagerClass.sharedInstance.tables[2].seconds = Int(TableManagerClass.sharedInstance.tables[2].elapsedTime)
        TableManagerClass.sharedInstance.tables[2].elapsedTime -= NSTimeInterval(TableManagerClass.sharedInstance.tables[2].seconds)
        
        TableManagerClass.sharedInstance.timerDisplay[2].text = NSString(format: "%02u:%02u:%02u", TableManagerClass.sharedInstance.tables[2].hour,TableManagerClass.sharedInstance.tables[2].minutes,TableManagerClass.sharedInstance.tables[2].seconds) as String
        if( (TableManagerClass.sharedInstance.tables[2].minutes + (TableManagerClass.sharedInstance.tables[2].hour * 60 )) <= 20){
            TableManagerClass.sharedInstance.tables[2].boardcost =  TableManagerClass.sharedInstance.tables[2].minimumcost
        } else {
            TableManagerClass.sharedInstance.tables[2].boardcost = (NSNumber(integer: TableManagerClass.sharedInstance.tables[2].hour).floatValue * 60 * TableManagerClass.sharedInstance.tables[2].cost)+(NSNumber(integer: TableManagerClass.sharedInstance.tables[2].minutes).floatValue
                * TableManagerClass.sharedInstance.tables[2].cost)
        }
        
        TableManagerClass.sharedInstance.tableAmount[2].text = NSString(format: "%.2f", TableManagerClass.sharedInstance.tables[2].boardcost) as String
        
        
    }
    
    func updateTime4(){
        
        
        if ( TableManagerClass.sharedInstance.tables[3].timeris_on == false || TableManagerClass.sharedInstance.tables[3].ispaused == true){
            return
        }
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        
        // Find difference between current time and start time
        if TableManagerClass.sharedInstance.tables[3].waspaused == true {
            let temp = TableManagerClass.sharedInstance.tables[3].resumedTime - TableManagerClass.sharedInstance.tables[3].pausedTime
            
            TableManagerClass.sharedInstance.tables[3].totalPausedInterval = TableManagerClass.sharedInstance.tables[3].totalPausedInterval + temp
            TableManagerClass.sharedInstance.tables[3].pausedTime = 0
            TableManagerClass.sharedInstance.tables[3].resumedTime = 0
            TableManagerClass.sharedInstance.tables[3].waspaused = false
            
        }
        
        TableManagerClass.sharedInstance.tables[3].elapsedTime = currentTime - TableManagerClass.sharedInstance.tables[3].startTime
        
        TableManagerClass.sharedInstance.tables[3].elapsedTime = TableManagerClass.sharedInstance.tables[3].elapsedTime - TableManagerClass.sharedInstance.tables[3].totalPausedInterval
        
        
        // Calculate minutes in elapsed time
        TableManagerClass.sharedInstance.tables[3].hour  = Int(TableManagerClass.sharedInstance.tables[3].elapsedTime/3600.0)
        TableManagerClass.sharedInstance.tables[3].elapsedTime -= (NSTimeInterval(TableManagerClass.sharedInstance.tables[3].hour)*3600)
        TableManagerClass.sharedInstance.tables[3].minutes = Int(TableManagerClass.sharedInstance.tables[3].elapsedTime/60.0)
        
        TableManagerClass.sharedInstance.tables[3].elapsedTime -= (NSTimeInterval(TableManagerClass.sharedInstance.tables[3].minutes)*60)
        
        TableManagerClass.sharedInstance.tables[3].seconds = Int(TableManagerClass.sharedInstance.tables[3].elapsedTime)
        TableManagerClass.sharedInstance.tables[3].elapsedTime -= NSTimeInterval(TableManagerClass.sharedInstance.tables[3].seconds)
        
        TableManagerClass.sharedInstance.timerDisplay[3].text = NSString(format: "%02u:%02u:%02u", TableManagerClass.sharedInstance.tables[3].hour,TableManagerClass.sharedInstance.tables[3].minutes,TableManagerClass.sharedInstance.tables[3].seconds) as String
        if( (TableManagerClass.sharedInstance.tables[3].minutes + (TableManagerClass.sharedInstance.tables[3].hour * 60 )) <= 20){
            TableManagerClass.sharedInstance.tables[3].boardcost =  TableManagerClass.sharedInstance.tables[3].minimumcost
        } else {
            TableManagerClass.sharedInstance.tables[3].boardcost = (NSNumber(integer: TableManagerClass.sharedInstance.tables[3].hour).floatValue * 60 * TableManagerClass.sharedInstance.tables[3].cost)+(NSNumber(integer: TableManagerClass.sharedInstance.tables[3].minutes).floatValue
                * TableManagerClass.sharedInstance.tables[3].cost)
        }
        
        TableManagerClass.sharedInstance.tableAmount[3].text = NSString(format: "%.2f", TableManagerClass.sharedInstance.tables[3].boardcost) as String
        
        
    }
    
    

    @IBAction func AddOnaction(sender: AnyObject) {
        
        var i = 0
        var addonString = ""
        for (i = 0 ; i < TableManagerClass.sharedInstance.tables[sender.tag].addons.count; i += 1) {
            
            addonString = addonString.stringByAppendingString("\( TableManagerClass.sharedInstance.tables[sender.tag].addons[i].description) ----> Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].addons[i].cost)\n")
        }
        
        addonString = addonString.stringByAppendingString("TOTAL - Rs.\(TableManagerClass.sharedInstance.tables[sender.tag].canteenCost + TableManagerClass.sharedInstance.tables[sender.tag].otherCost)")
        let alert1 = UIAlertController(title: "Enter Add on Details\n=====================\n\(addonString)\n" as String,
                                       message: " ",
                                       preferredStyle: .Alert)
        
        let addAction = UIAlertAction(title: "Canteen",
                                        style: .Default) { (action: UIAlertAction!) -> Void in
                                            if (alert1.textFields![1].text! == "" ||
                                                alert1.textFields![0].text! == "" ) {
                                                alert1.dismissViewControllerAnimated(true, completion: nil)
                                                self.popupAlert("Enter valid details. Both fields are mandatory")
                                                return
                                            }
                                          
                                        
                                        var cost = Float(0.0)
                                        var addon = Addon(descript: "", value: 0.0)
                                        if alert1.textFields![2].text! == "" {
                                            cost =  (alert1.textFields![1].text! as NSString).floatValue
                                            addon = Addon(descript:"(\(alert1.textFields![0].text!) * 1)", value: cost)
                                            
                                            TableManagerClass.sharedInstance.tables[sender.tag].addons.append(addon)
                                            
                                        } else {
                                            cost = (alert1.textFields![1].text! as NSString).floatValue * (alert1.textFields![2].text! as NSString).floatValue
                                             addon = Addon(descript:"(\(alert1.textFields![0].text!) * \(alert1.textFields![2].text!))", value: cost)
                                            TableManagerClass.sharedInstance.tables[sender.tag].addons.append(addon)
                                            
                                        }
                                        
                                            
        //TableManagerClass.sharedInstance.tables[sender.tag].AddonCost += cost
        TableManagerClass.sharedInstance.tables[sender.tag].canteenCost += cost
        TableManagerClass.sharedInstance.tables[sender.tag].addonstring = TableManagerClass.sharedInstance.tables[sender.tag].addonstring + "/" + addon.description
        
       // print("items \(TableManagerClass.sharedInstance.tables[sender.tag].AddonCost)")
           alert1.dismissViewControllerAnimated(true, completion: nil)
                                            
        }
        
        let othersAddAction = UIAlertAction(title: "Other",
                                      style: .Default) { (action: UIAlertAction!) -> Void in
                                        
                                   if (alert1.textFields![1].text! == "" ||
                                    alert1.textFields![0].text! == "" ) {
                                    alert1.dismissViewControllerAnimated(true, completion: nil)
                                    self.popupAlert("Enter valid details. Both fields are mandatory")
                                    return
                                        }
                                       
                                            
                                        var cost = Float(0.0)
                                        var addon = Addon(descript: "", value: 0.0)
                                        if alert1.textFields![2].text! == "" {
                                            cost =  (alert1.textFields![1].text! as NSString).floatValue 
                                             addon = Addon(descript:"(\(alert1.textFields![0].text!) * 1)", value: cost)
                                            
                                            TableManagerClass.sharedInstance.tables[sender.tag].addons.append(addon)
                                            
                                        } else {
                                            cost = (alert1.textFields![1].text! as NSString).floatValue * (alert1.textFields![2].text! as NSString).floatValue
                                              addon = Addon(descript:"(\(alert1.textFields![0].text!) * \(alert1.textFields![2].text!))", value: cost)
                                            TableManagerClass.sharedInstance.tables[sender.tag].addons.append(addon)
                                            
                                        }
                                        
                                       //   TableManagerClass.sharedInstance.tables[sender.tag].AddonCost += cost
                                        TableManagerClass.sharedInstance.tables[sender.tag].otherCost += cost
                                        TableManagerClass.sharedInstance.tables[sender.tag].addonstring = TableManagerClass.sharedInstance.tables[sender.tag].addonstring + "/" + addon.description
                                        
                                         alert1.dismissViewControllerAnimated(true, completion: nil)
                                     //   print("items \(TableManagerClass.sharedInstance.tables[sender.tag].AddonCost)")
                                        
                                        
        }

        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction!) -> Void in
                                            alert1.dismissViewControllerAnimated(true, completion: nil)
                                            
        }
        
        alert1.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Description"
        })
        
        alert1.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Cost"
        })
        
        alert1.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Quantity"
        })
        
        
        alert1.addAction(addAction)
        alert1.addAction(othersAddAction)
        alert1.addAction(cancelAction)
        
        
        self.presentViewController(alert1,
                                   animated: true,
                                   completion: nil)

    }
    

    @IBOutlet weak var tableView2: UIView!
    
    @IBOutlet weak var timerButton2: UIButton!
    
    @IBOutlet weak var tableAmount2: UILabel!
    
    @IBOutlet weak var timerDisplay2: UILabel!
    
    @IBOutlet weak var playerName2: UITextField!
    
    @IBAction func timerAction2(sender: AnyObject) {
    }
    
   
    
 
    @IBOutlet weak var tableView3: UIView!
    
    @IBOutlet weak var timerButton3: UIButton!
    
    @IBOutlet weak var tableAmount3: UILabel!
    
    @IBOutlet weak var timerDisplay3: UILabel!
    
    @IBOutlet weak var playerName3: UITextField!
    
    @IBAction func timerAction3(sender: AnyObject) {
    }
 

  
    @IBOutlet weak var tableView4: UIView!
    
    @IBOutlet weak var timerButton4: UIButton!
    
    @IBOutlet weak var tableAmount4: UILabel!
    
    @IBOutlet weak var timerDisplay4: UILabel!
    
    @IBOutlet weak var playerName4: UITextField!
    
    @IBAction func timerAction4(sender: AnyObject) {
    }
    
   
    

    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
       }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      
        
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
       
    }

    @IBAction func playerNameEntered(sender: AnyObject) {
               TableManagerClass.sharedInstance.tables[sender.tag].playername = TableManagerClass.sharedInstance.playerName[sender.tag].text!
    }
    
    @IBAction func phoneNoEntered(sender: AnyObject) {
        
        TableManagerClass.sharedInstance.tables[sender.tag].phoneno = TableManagerClass.sharedInstance.phoneNo[sender.tag].text!
    }
    
    func sendEmail(subject: String, body: String, attachment: Bool, delete: Bool,filepath: String) {
        
        let appDelegate1 = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext1 = appDelegate1.managedObjectContext
        
        let fetchRequest1 = NSFetchRequest(entityName: "ChargeSheet")
        var updated =  [NSManagedObject]()
        
       if delete {
            do {
                let results =
                try managedContext1.executeFetchRequest(fetchRequest1)
                updated = results as! [NSManagedObject]
               
                if updated.count != 0  {
                   
                    
                    if ((updated[0].valueForKey("updateSent") as! Bool)) {
                        
                        return
                        
                    }
                    
                } else {
                    return
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }

        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Records")
        var recordsList =  [NSManagedObject]()
        
       
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = "tipntopclub@gmail.com"
        smtpSession.password = "Weedsmoker89"
        smtpSession.port = 465
        smtpSession.authType = MCOAuthType.SASLPlain
        smtpSession.connectionType = MCOConnectionType.TLS
        smtpSession.connectionLogger = {(connectionID, type, data) in
            if data != nil {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding){
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
        
        // 2
            let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "TipNTop", mailbox: "tipntopclub@gmail.com")]
        if attachment {
            builder.header.to.append(MCOAddress(displayName: "Dinesh", mailbox: "gdine89@gmail.com"))
        }
        builder.header.from = MCOAddress(displayName: "TipNTop", mailbox: "tipntopclub@gmail.com")
        builder.header.subject = subject
        builder.htmlBody = body
        
        if attachment {
            builder.addAttachment(MCOAttachment(contentsOfFile: filepath))
        }
        let rfc822Data = builder.data()
        
        

        let sendOperation = smtpSession.sendOperationWithData(rfc822Data)
        sendOperation.start { (error) -> Void in
            if (error != nil) {
               // NSLog("Error sending email: \(error)")
                if attachment {
                self.popupAlert("Error sendig mail!!!")
                }

                
            } else {
                if attachment {
                    self.popupAlert("Mail sent succesfuuly")
            }
                // NSLog("Successfully sent email!")
               
                if delete {
                    do {
                        let results =
                            try managedContext.executeFetchRequest(fetchRequest)
                        recordsList = results as! [NSManagedObject]
                    } catch let error as NSError {
                        print("Could not fetch \(error), \(error.userInfo)")
                    }
                    
                    for object in recordsList {
                        managedContext.deleteObject(object)
                    }
                    
                    do {
                        try managedContext.save()
                        //5
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                    if updated.count != 0 {
                        updated[0].setValue(true, forKey: "updateSent")
                    }
                    
                    do {
                        try managedContext1.save()
                        //5
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                    self.updateBatchno(1)


                }
               
            }
            
            }
        
       


    }
    
    func updateBatchno(bno: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Batchno")
        var batchno_result =  [NSManagedObject]()
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            batchno_result = results as! [NSManagedObject]
            
            if batchno_result.count != 0  {
             batchno_result[0].setValue(bno, forKey: "no")
            
                do {
                    try managedContext.save()
                    //5
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            } else {
                let entity =  NSEntityDescription.entityForName("Batchno",inManagedObjectContext:managedContext)
                
                let record = NSManagedObject(entity: entity!,insertIntoManagedObjectContext: managedContext)

                record.setValue(1, forKey: "no")
                
                do {
                    try managedContext.save()
                    //5
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                
            }
            
           

        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        

    }
    
    func getbatchno() -> Int {
        var batch_no = 1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Batchno")
        var batchno_result =  [NSManagedObject]()
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            batchno_result = results as! [NSManagedObject]
            
            if batchno_result.count != 0  {
               batch_no = (batchno_result[0].valueForKey("no") as! NSNumber).integerValue
                
            }
           } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
         return batch_no
        
    }
    
    @IBAction func sendRecordsInMail(sender: AnyObject) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
      
        
        dateFormatter.timeZone = NSTimeZone()
        let dateString = dateFormatter.stringFromDate(NSDate())
        
       
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Records")
        var recordsList =  [NSManagedObject]()
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            recordsList = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        // 2
        let exportFilePath =
            NSTemporaryDirectory() + "statement.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        NSFileManager.defaultManager().createFileAtPath(
            exportFilePath, contents: NSData(), attributes: nil)
        let fileHandle: NSFileHandle?
        do {
            fileHandle = try NSFileHandle(forWritingToURL: exportFileURL)
        } catch {
            let nserror = error as NSError
            print("ERROR: \(nserror)")
            fileHandle = nil
        }
        
        print("date: \(dateString)")
        

        var daily_statement_string = ""
        var t_boardcost = Float(0.0)
        var t_canteencost = Float(0.0)
        var t_othercost = Float(0.0)
        var t_totalcost = Float(0.0)
        
        if let fileHandle = fileHandle{
            // 4
            var header = ", , , , , , ,Tip N Top Cue Sports\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)

            
            header = ",\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)

            header = " , Board Sales, Canteen Sales, Other Sales, Total Sales\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)

            header = "Sales,"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)

            header = returnChargesString()
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = ",\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            

            
            header =  "BatchNo,Table No,Name,Phone No,Start Time,End Time,Duration,Paused Time," +
            "Board Cost,Canteen Cost,Other Cost,Total Cost,Discount,Addon Detail\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
    
    //        dateFormatter.
            var boardcost = Float(0.0)
            var canteencost = Float(0.0)
            var othercost = Float(0.0)
            var totalcost = Float(0.0)
            
            
            for object in recordsList {
                let journalEntry = object as! Records
                boardcost += (journalEntry.boardBill?.floatValue)!
                canteencost += (journalEntry.canteenCost?.floatValue)!
                othercost += (journalEntry.otherCost?.floatValue)!
                totalcost += (journalEntry.totalBill?.floatValue)!
                
                let string_data = journalEntry.csv()
                fileHandle.seekToEndOfFile()
                let csvData = string_data.dataUsingEncoding(
                    NSUTF8StringEncoding, allowLossyConversion: false)
                fileHandle.writeData(csvData!)
                
                print("main string: \(string_data)")
                if string_data.rangeOfString(dateString) != nil {
                    t_boardcost += (journalEntry.boardBill?.floatValue)!
                    t_canteencost += (journalEntry.canteenCost?.floatValue)!
                    t_othercost += (journalEntry.otherCost?.floatValue)!
                    t_totalcost += (journalEntry.totalBill?.floatValue)!

                   daily_statement_string =  daily_statement_string.stringByAppendingString(string_data)
                }
                
                
                
            }
            
            header = ",\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = " , Board Sales, Canteen Sales, Other Sales, Total Sales\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = "Current Sales,"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = "\(boardcost),\(canteencost),\(othercost),\(totalcost)"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            
            // 5
            fileHandle.closeFile()
            
            self.sendEmail("Record Statement", body: " ",attachment: true,delete: false,filepath: exportFilePath)
            
        }
        

        let exportFilePath1 =
            NSTemporaryDirectory() + "daily_statement.csv"
        let exportFileURL1 = NSURL(fileURLWithPath: exportFilePath1)
        NSFileManager.defaultManager().createFileAtPath(
            exportFilePath1, contents: NSData(), attributes: nil)
        let fileHandle1: NSFileHandle?
        do {
            fileHandle1 = try NSFileHandle(forWritingToURL: exportFileURL1)
        } catch {
            let nserror = error as NSError
            print("ERROR: \(nserror)")
            fileHandle1 = nil
        }
        

        if let fileHandle = fileHandle1{
            
            var header = ", , , , , , ,Tip N Top Cue Sports\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header =  "BatchNo,Table No,Name,Phone No,Start Time,End Time,Duration,Paused Time," +
            "Board Cost,Canteen Cost,Other Cost,Total Cost,Discount,Addon Detail\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            print("string: \(daily_statement_string)")
            fileHandle.writeData(daily_statement_string.dataUsingEncoding(
                NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = ",\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = " , Board Sales, Canteen Sales, Other Sales, Total Sales\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = "Current Sales,"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = "\(t_boardcost),\(t_canteencost),\(t_othercost),\(t_totalcost)"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            
            fileHandle.closeFile()
            
            self.sendEmail("Daily Statement for \(dateString)", body: " ",attachment: true,delete: false,filepath: exportFilePath1)
            
        }
    }
   
   

    func sendMonthlyupdate() {
      
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Records")
        var recordsList =  [NSManagedObject]()
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            recordsList = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        // 2
        
        let date = NSDate()
        let components = NSCalendar.currentCalendar().components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year] , fromDate: date)
        
        let df = NSDateFormatter()
        var monthstring = ""
        if components.month == 1 {
            monthstring = df.monthSymbols[11]
        } else {
            monthstring = df.monthSymbols[components.month - 2]
        }
        
        let exportFilePath =
            NSTemporaryDirectory() + "\(monthstring)_\(components.year).csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        NSFileManager.defaultManager().createFileAtPath(
            exportFilePath, contents: NSData(), attributes: nil)
        let fileHandle: NSFileHandle?
        do {
            fileHandle = try NSFileHandle(forWritingToURL: exportFileURL)
        } catch {
            let nserror = error as NSError
            print("ERROR: \(nserror)")
            fileHandle = nil
        }
        
        
        
        if let fileHandle = fileHandle {
            // 4
            
            var header = ", , , , , , ,Tip N Top Cue Sports\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = ",\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = " , Board Sales, Canteen Sales, Other Sales, Total Sales\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            
            header = "Sales,"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = returnChargesString()
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = ",\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            

            header =  "BatchNo,Table No,Name,Phone No,Start Time,End Time,Duration,Paused Time," +
            "Board Cost,Canteen Cost,Other Cost,Total Cost,Discount,Addon Detail\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            var boardcost = Float(0.0)
            var canteencost = Float(0.0)
            var othercost = Float(0.0)
            var totalcost = Float(0.0)
            
            
            for object in recordsList {
                let journalEntry = object as! Records
                boardcost += (journalEntry.boardBill?.floatValue)!
                canteencost += (journalEntry.canteenCost?.floatValue)!
                othercost += (journalEntry.otherCost?.floatValue)!
                totalcost += (journalEntry.totalBill?.floatValue)!
                fileHandle.seekToEndOfFile()
                let csvData = journalEntry.csv().dataUsingEncoding(
                    NSUTF8StringEncoding, allowLossyConversion: false)
                fileHandle.writeData(csvData!)
            }
          
            header = ",\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = " , Board Sales, Canteen Sales, Other Sales, Total Sales\n"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = "Current Sales,"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            header = "\(boardcost),\(canteencost),\(othercost),\(totalcost)"
            fileHandle.writeData(header.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            
            // 5
            fileHandle.closeFile()
            
            
            self.sendEmail("Monthly Statement for \(monthstring) \(components.year)", body: " ",attachment: true,delete: true,filepath: exportFilePath)
            
            
        }
    }
    
    func updateCharges(boardcost: Float, canteencost: Float, othercost: Float, totalcost: Float) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ChargeSheet")
        var updated =  [NSManagedObject]()
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            updated = results as! [NSManagedObject]
            
            if updated.count == 0  {
               
                let entity =  NSEntityDescription.entityForName("ChargeSheet",inManagedObjectContext:managedContext)
                
                let record = NSManagedObject(entity: entity!,insertIntoManagedObjectContext: managedContext)
                

                record.setValue(boardcost, forKey: "boardcost")
                record.setValue(canteencost, forKey: "canteencost")
                record.setValue(othercost, forKey: "othercost")
                record.setValue(totalcost, forKey: "totalcost")
                record.setValue(false, forKey: "updateSent")
                
                self.checkandsendupdate()
                
            } else  {
                
                updated[0].setValue(((updated[0].valueForKey("boardcost") as! NSNumber).floatValue + boardcost), forKey: "boardcost")
                updated[0].setValue(((updated[0].valueForKey("canteencost") as! NSNumber).floatValue + canteencost), forKey: "canteencost")
                updated[0].setValue(((updated[0].valueForKey("othercost") as! NSNumber).floatValue + othercost), forKey: "othercost")
                updated[0].setValue(((updated[0].valueForKey("totalcost") as! NSNumber).floatValue + totalcost), forKey: "totalcost")
                self.checkandsendupdate()
                
                
            }
            
            do {
                try managedContext.save()
                
                //5
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            

        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        
    }
    
    func returnChargesString() -> String {
        var returnstring = ""
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ChargeSheet")
        var updated =  [NSManagedObject]()
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            updated = results as! [NSManagedObject]
            
            if updated.count != 0  {
                
               returnstring = "\((updated[0].valueForKey("boardcost") as! NSNumber).floatValue), \((updated[0].valueForKey("canteencost") as! NSNumber).floatValue), \((updated[0].valueForKey("othercost") as! NSNumber).floatValue), \((updated[0].valueForKey("totalcost") as! NSNumber).floatValue)\n"
                
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return returnstring ;
        
    }
    

    func popupAlert(string: String) {
        
        let alert1 = UIAlertController(title: string as String,
                                       message: " ",
                                       preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Ok",
                                         style: .Default) { (action: UIAlertAction!) -> Void in
                                            alert1.dismissViewControllerAnimated(true, completion: nil)
                                            
        }
        
        alert1.addAction(cancelAction)
        
        
        self.presentViewController(alert1,
                                   animated: true,
                                   completion: nil)

        
    }
    
    func chooseAction(string: String) -> Bool{
        
        var ret_val = false
        let alert1 = UIAlertController(title: string as String,
                                       message: " ",
                                       preferredStyle: .Alert)
        let okaction = UIAlertAction(title: "Ok",
                                         style: .Default) { (action: UIAlertAction!) -> Void in
                                            ret_val = true
                                            
                                            alert1.dismissViewControllerAnimated(true, completion: nil)
                                            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .Default) { (action: UIAlertAction!) -> Void in
                                        ret_val =  false
                                        
                                        alert1.dismissViewControllerAnimated(true, completion: nil)
                                        
        }
        alert1.addAction(okaction)
        alert1.addAction(cancelAction)
        
        
        self.presentViewController(alert1,
                                   animated: true,
                                   completion: nil)
        
        return ret_val
    }
    
    func cleartable(tableno: Int) {
        
        TableManagerClass.sharedInstance.phoneNo[tableno].text = nil
        TableManagerClass.sharedInstance.playerName[tableno].text = nil
        TableManagerClass.sharedInstance.timerDisplay[tableno].text = "00:00:00"
        TableManagerClass.sharedInstance.tableAmount[tableno].text = "Rs.0.0"
    
    }

    var pageSize:CGSize!
    
    @IBOutlet weak var txtView: UITextView!
    
    func printBill(stringToPrint: String) {
        
        txtView.text = stringToPrint
        let pic:UIPrintInteractionController = .sharedPrintController()
        let viewpf:UIViewPrintFormatter = txtView.viewPrintFormatter()
        
        pic.showsPageRange = true
        pic.printFormatter = viewpf
        pic.presentAnimated(true, completionHandler: nil)
          }
    
   
}
