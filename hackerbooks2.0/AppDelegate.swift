//
//  AppDelegate.swift
//  hackerbooks2.0
//
//  Created by fran on 15/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import UIKit
import CoreData
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let model = CoreDataStack(modelName: "Model")!
    let url = URL(string: "https://keepcodigtest.blob.core.windows.net/containerblobstest/books_readable.json")!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //try! model.dropAllData()
        
        let req : NSFetchRequest<BookTag> = BookTag.fetchRequest()
        
        req.includesPropertyValues = false
        req.sortDescriptors = [NSSortDescriptor(key: "tag.importance", ascending: false),NSSortDescriptor(key:"tag.name",ascending:true)]
        var count = 0
        do{
            count = try self.model.context.count(for: req)
        }catch{
            print("error")
        }
        if count == 0 {
            let jsonManager = JSONManager(url: url, model: model)
            
            jsonManager.downloadBooks()
            let _ = Tag(name: "Favorites", importance: true, inContext: self.model.context)
            
        }
        //self.model.autoSave(10)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: model.context, sectionNameKeyPath: "tag.name", cacheName: nil)
        
        let tabVC = BooksViewController(fetchedResultsController: fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = UINavigationController(rootViewController: tabVC)
        
        window?.makeKeyAndVisible()
        
           

        
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        self.model.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.model.save()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.model.save()
    }


}

