//
//  AppDelegate.swift
//  LastCircleSwift
//
//  Created by Wang Shudao on 9/1/15.
//  Copyright © 2015 MAD. All rights reserved.
//

import UIKit
import CloudKit

let recordType = "RTYPE_BEST"
let recordName = "RNAME_BEST"
let recordKey = "RKEY_BEST"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var wbToken: String?
    var cloudRecord: CKRecord?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        CKContainer.defaultContainer().accountStatusWithCompletionHandler({ (status, error) -> Void in
            if (status == CKAccountStatus.NoAccount) {
                print("iCloud no account when fetching")
            } else {
                let recordID = CKRecordID(recordName: recordName)
                let container = CKContainer.defaultContainer()
                let publicDatabase = container.publicCloudDatabase
                publicDatabase.fetchRecordWithID(recordID, completionHandler: { (record, error) -> Void in
                    if error == nil {
                        if let rec = record {
                            self.cloudRecord = rec
                            print("iCloud fetch successed")
                            let cloudBest = rec[recordKey] as! Int
                            if cloudBest > ScoreManager.sharedManager.best {
                                ScoreManager.sharedManager.best = cloudBest
                            }
                        }
                    } else {
                        print("iCloud fetch failed: \(error)")
                    }
                })
            }
        })

        
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // iCloud saving
        CKContainer.defaultContainer().accountStatusWithCompletionHandler({ (status, error) -> Void in
            if (status == CKAccountStatus.NoAccount) {
                print("iCloud no account when saving")
            } else {
                let recordID = CKRecordID(recordName: recordName)
                var record = self.cloudRecord
                
                if record == nil {
                    record = CKRecord(recordType: recordType, recordID: recordID)
                }
                record![recordKey] = ScoreManager.sharedManager.best
                let container = CKContainer.defaultContainer()
                let publicDatabase = container.publicCloudDatabase
                publicDatabase.saveRecord(record!, completionHandler: { (record, error) -> Void in
                    if error == nil {
                        print("iCloud save successed")
                    } else {
                        print("iCloud save failed: \(error)")
                    }
                })
            }
        })
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

