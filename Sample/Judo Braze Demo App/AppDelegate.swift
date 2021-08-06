//
//  AppDelegate.swift
//  Judo Braze Demo App
//
//  Created by Andrew Clunis on 2021-08-06.
//

import UIKit
import JudoSDK
import JudoModel
import AppboyKit
import Judo_Braze

@main
class AppDelegate: UIResponder, UIApplicationDelegate, ABKInAppMessageControllerDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Judo:
        Judo.initialize(accessToken: "<JUDO TOKEN>", domain: "<JUDO DOMAIN>")

        // Initialize Braze:
        Appboy.start(withApiKey: "<BRAZE API TOKEN>", in:application, withAppboyOptions: [ABKEndpointKey: "<MY-BRAZE-ENDPOINT>"])
                
        // Identify our user to Braze:
        Appboy.sharedInstance()?.changeUser("me@judo.app")

        // Ask the Judo-Braze module to wire up automatic event tracking into Braze:
        Judo.sharedInstance.integrateWithBraze()
        
        // in this toy Sample App, we've conformed AppDelegate to ABKInAppMessageControllerDelegate, so now we'll set it as the IAP message controller's delegate:
        Appboy.sharedInstance()?.inAppMessageController.delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    @IBAction func buttonClicked(_ sender: Any) {
        // Fire a Braze Event. If you have an appropriate campaign set up in your Braze settings for this event to open an IAP with the `judo-experience` extra field added, then this should open the Experience.
        Appboy.sharedInstance()?.logCustomEvent("My Test Event")
    }
    
    // MARK: ABKInAppMessageControllerDelegate
    
    /// This is the ABKInAppMessageControllerDelegate's before(inAppMessageDisplayed:) template method you should implement to inject the Judo-Braze behaviour in.
    func before(inAppMessageDisplayed inAppMessage: ABKInAppMessage) -> ABKInAppMessageDisplayChoice {
        return Judo.sharedInstance.brazeBeforeInAppMessageDisplayed(inAppMessageDisplayed: inAppMessage) ?? .displayInAppMessageNow
    }
}
