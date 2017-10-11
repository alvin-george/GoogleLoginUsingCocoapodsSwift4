//
//  AppDelegate.swift
//  GooglePlusUsingCocoapods
//
//  Created by Pushpam Group on 25/03/17.
//  Copyright © 2017 Pushpam Group. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        //assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "599280904951-9usr5as4773rkimklle3o6a08q3tui4i.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "599280904951-il34rh0tagk0f8406bdltiei6ioh4fsa.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().shouldFetchBasicProfile =  true
        GIDSignIn.sharedInstance().delegate = self
        
        return true
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
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let result = GIDSignIn.sharedInstance().handle(url,
                //added exclamation mark
                sourceApplication: String(describing: options[UIApplicationOpenURLOptionsKey.sourceApplication]!),
                annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return result
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("on app delegate didSignInFor ")
        
        if (error == nil) {
            
            print("user Data is fetched")
            print(user.userID)
            
        } else {
            print("\(error.localizedDescription)")
        }
        
    }
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}

