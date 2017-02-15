//
//  AppDelegate.swift
//  insert
//
//  Created by David Johnson on 1/18/17.
//  Copyright © 2017 David Johnson. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        DatabaseController.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        for i in 1...5 {
//            
//            let insert:Insert = NSEntityDescription.insertNewObject(forEntityName: "Insert", into: DatabaseController.getContext()) as! Insert
//            
//            let index = String(i)
//            
//            insert.preferredIndex   = Int16(i)
//            insert.content          = "Content" + index
//            insert.title            = "Title" + index
//            insert.url              = "www.url.com" + index
//            insert.createdAt        = Date().timeIntervalSince1970
//            
//        }
        
        
//                for i in 1...5 {
//        
//                    let insert:GroupedInsert = NSEntityDescription.insertNewObject(forEntityName: "GroupedInsert", into: DatabaseController.getContext()) as! GroupedInsert
//        
//                    let index = String(i)
//        
//                    insert.preferredIndex   = Int16(i)
//                    insert.content          = "Content" + index
//                    insert.title            = "Title" + index
//                    insert.groupID              = "www.url.com" + index
//                    insert.createdAt        = Date().timeIntervalSince1970
//                    
//                }

//        let fetchReq:NSFetchRequest<Insert> = Insert.fetchRequest()
//        let fetchReqGr:NSFetchRequest<GroupedInsert> = GroupedInsert.fetchRequest()
//        do {
//            
//            let searchResults = try DatabaseController.getContext().fetch(fetchReqGr)
//            
//            print("Number of results: \(searchResults.count)")
//            
//            for result in searchResults as [GroupedInsert] {
//                
//                //                print("\(result.preferredIndex) \(result.content!) \(result.title!) \(result.url!) \(result.createdAt)")
//                
//                print("\(result)")
//                
//                                DatabaseController.getContext().delete(result)
//                
//            }
//            
//        } catch {
//            
//            print("Error: \(error)")
//            
//        }
//        
////
//        do {
//            
//            let searchResults = try DatabaseController.getContext().fetch(fetchReq)
//            
//            print("Number of results: \(searchResults.count)")
//            
//            for result in searchResults as [Insert] {
//                
////                print("\(result.preferredIndex) \(result.content!) \(result.title!) \(result.url!) \(result.createdAt)")
//                
//                print("\(result)")
//                
//                DatabaseController.getContext().delete(result)
//                
//            }
//            
//        } catch {
//            
//            print("Error: \(error)")
//            
//        }
//        DatabaseController.saveContext()
//
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        DatabaseController.saveContext()
    }

}

