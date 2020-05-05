//
//  LoginViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 5/5/20.
//  Copyright © 2020 David Fisher. All rights reserved.
//

import UIKit
import Firebase
import Rosefire
import GoogleSignIn

class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
@IBOutlet weak var signInButton: GIDSignInButton!

  let showListSegueIdentifier = "ShowListSegue"
  let REGISTRY_TOKEN = "134f3a4e-9824-460f-9d03-2aac04b76ec4"

  override func viewDidLoad() {
    emailTextField.placeholder = "Email";
    passwordTextField.placeholder = "Password"

    GIDSignIn.sharedInstance()?.presentingViewController = self
//    GIDSignIn.sharedInstance().signIn()

    signInButton.style = .wide
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.loginViewController = self
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if Auth.auth().currentUser != nil {
      self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
    }
  }

  @IBAction func pressedSignUp(_ sender: Any) {
    let email = emailTextField.text!
    let password = passwordTextField.text!

    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      if error != nil {
        print("Login error! \(error!)")
        return
      }
      self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
    }
  }
  
  @IBAction func pressedLoginIn(_ sender: Any) {
    let email = emailTextField.text!
    let password = passwordTextField.text!

    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
      if error != nil {
        print("Login error! \(error!)")
        return
      }
      self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
    }
  }
  
  @IBAction func pressedRosefireLogin(_ sender: Any) {
    Rosefire.sharedDelegate().uiDelegate = self // This should be your view controller
    Rosefire.sharedDelegate().signIn(registryToken: REGISTRY_TOKEN) { (err, result) in

      if let err = err {
        print("Rosefire error! \(err)")
        return
      }
      print("Result = \(result!.token!)")
      print("Result = \(result!.username!)")
      print("Result = \(result!.name!)")
      print("Result = \(result!.email!)")
      print("Result = \(result!.group!)")
      Auth.auth().signIn(withCustomToken: result!.token) { (authResult, error) in
        if let error = error {
          print("Firebase signIn error! \(error)")
          return
        }
        self.performSegue(withIdentifier: self.showListSegueIdentifier, sender: self)
      }
    }
  }
}
