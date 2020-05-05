//
//  AppDelegate.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/28/20.
//  Copyright © 2020 David Fisher. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

  var loginViewController: LoginViewController!


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    FirebaseApp.configure()
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance().delegate = self
    let db = Firestore.firestore()
    let settings = db.settings
    settings.areTimestampsInSnapshotsEnabled = true
    db.settings = settings
    return true
  }

  func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
  }

  //  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
  //    return GIDSignIn.sharedInstance().handle(url,
  //                                             sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
  //                                             annotation: [:])
  //  }

  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
    if let error = error {
      print("Error with Google auth.  error: \(error.localizedDescription)")
      return
    }

    guard let authentication = user.authentication else { return }
    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                   accessToken: authentication.accessToken)
    print("Your are now signed in with Google, now use the credential to sign in to Firebase")
    Auth.auth().signInAndRetrieveData(with: credential, completion: { (authResult, error) in
      if error != nil {
        print("Login error! \(error!)")
        return
      }
      print("Signed in using Google auth!")
      self.loginViewController.performSegue(withIdentifier: self.loginViewController.showListSegueIdentifier,
                                            sender: self.loginViewController)
    })
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


}

