//
//  AppDelegate.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 08/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyDBx2r5-Oabb6m5qmWzG0DOFtCf0rl7OIE")
        GMSPlacesClient.provideAPIKey("AIzaSyDBx2r5-Oabb6m5qmWzG0DOFtCf0rl7OIE")
        if UserDefaults.standard.object(forKey: "idCurrentUser") != nil {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
             let nc = UINavigationController(rootViewController: vc)
             nc.isNavigationBarHidden = true
            self.window?.rootViewController = nc
        }
      
//        //        let isUserLoggedIn:Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
//
//        if A != nil {
//            let userStoryboard = UIStoryboard(name: "User", bundle: nil)
//            let vc = userStoryboard.instantiateViewController(withIdentifier: "TabBarViewController")
//            let nc = UINavigationController(rootViewController: vc)
//            nc.isNavigationBarHidden = true
//            self.window?.rootViewController = nc
//        }
//        
//        var rootViewController = self.window!.rootViewController
//        let isUserLoggedIn:Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
//        if(isUserLoggedIn) {
//            let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
//            let protectedPage = mainStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//            window!.rootViewController = protectedPage
//            window!.makeKeyAndVisible()
//        }
//        else{
//            let mainStoryboard = UIStoryboard(name: "Main" , bundle: nil)
//            let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            window!.rootViewController = loginViewController
//            window!.makeKeyAndVisible()
//
//
//        }
//        

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


}

