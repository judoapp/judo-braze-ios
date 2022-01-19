import Foundation
import AppboyKit
import JudoModel
import JudoSDK

private var observerChit: NSObjectProtocol!

public extension Judo {
    /// Call this method to automatically track Judo events into Braze.
    ///
    /// Note to enable IAM integration there is further work to do, please see the documentation included with this module.
    func integrateWithBraze() {
        if #available(iOS 13.0, *) {
            observerChit = NotificationCenter.default.addObserver(
                forName: Judo.screenViewedNotification,
                object: nil,
                queue: OperationQueue.main,
                using: { notification in
                    let screen = notification.userInfo!["screen"] as! Screen
                    let experience = notification.userInfo!["experience"] as! Experience
                    let properties = [
                        "screenID": screen.id,
                        "screenName": screen.name ?? "Screen",
                        "experienceID": experience.id,
                        "experienceName": experience.name
                    ]
                    
                    Appboy.sharedInstance()?.logCustomEvent("Judo Screen Viewed", withProperties: properties)
                }
            )
        }
    }
    
    /// This method a helper for launching Judo Experiences when a `judo-experience` extra is added to a Braze In-App Message, which you can use from a  `ABKInAppMessageControllerDelegate`. See the documentation included with this module for more details.
    func brazeBeforeInAppMessageDisplayed(inAppMessageDisplayed inAppMessage: ABKInAppMessage) -> ABKInAppMessageDisplayChoice? {
        // https://www.braze.com/docs/developer_guide/platform_integration_guides/ios/in-app_messaging/implementation_guide/#custom-slideup-in-app-message
        
        if let urlString = inAppMessage.extras?["judo-experience"] as? String, let experienceURL = URL(string: urlString) {
            Judo.sharedInstance.openURL(experienceURL, animated: true)
            inAppMessage.logInAppMessageImpression()
            // Since we are doing our own behaviour, inhibit Braze's built-in IAM UI from displaying anything.
            return ABKInAppMessageDisplayChoice.discardInAppMessage
        }
        return nil
    }
}
