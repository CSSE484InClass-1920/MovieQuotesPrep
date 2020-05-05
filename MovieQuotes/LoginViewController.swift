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

class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!

  let showListSegueIdentifier = "ShowListSegue"

  override func viewDidLoad() {
    emailTextField.placeholder = "Email";
    passwordTextField.placeholder = "Password"
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
  }
}
