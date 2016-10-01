//
//  AppDelegate.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-07-19.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import Fabric
import TwitterKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    override init() {
        super.init()
        FIRApp.configure()
    }
    
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FIRDatabase.database().persistenceEnabled = true
        
        Fabric.with([Twitter.self])
        
        return true

        
        // check to see if user already signed in
        
//        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
//            if let user = user {
//                // user already signed in
//                print("AppDelegate: RGM: the user, \(user), is already signed in.")
//                
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let viewController: DetailView = storyboard.instantiateViewController(withIdentifier: "ViewController") as! DetailView
//                
//                let rootViewController = self.window?.rootViewController as! UINavigationController
//                rootViewController.pushViewController(viewController, animated: true)
//                // self.performSegue(withIdentifier: "goToPostFeed", sender: nil)
//            }
//        })
        
            }
    

    private func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

