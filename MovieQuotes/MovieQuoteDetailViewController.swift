//
//  MovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/28/20.
//  Copyright © 2020 David Fisher. All rights reserved.
//

import UIKit
import Firebase

var movieQuoteListener: ListenerRegistration!

class MovieQuoteDetailViewController: UIViewController {
  @IBOutlet weak var quoteLabel: UILabel!
  @IBOutlet weak var movieLabel: UILabel!
  var movieQuote: MovieQuote?
  var movieQuoteRef: DocumentReference?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @objc func showEditDialog() {

        let alertController = UIAlertController(title: "Edit movie quote",
    message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) -> Void in
        textField.text = self.movieQuote?.quote
          textField.placeholder = "Quote"
        }
        alertController.addTextField { (textField) -> Void in
        textField.text = self.movieQuote?.movie
          textField.placeholder = "Movie title"
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: UIAlertAction.Style.cancel) { (action) -> Void in
          print("You pressed cancel")
        }
        let editQuoteAction = UIAlertAction(title: "Edit Quote",
                                              style: UIAlertAction.Style.default) { (action) -> Void in
          let quoteTextField = alertController.textFields![0] as UITextField
          let movieTextField = alertController.textFields![1] as UITextField
//          print("Quote: \(quoteTextField.text!)")
//          print("Movie: \(movieTextField.text!)")

//                                                self.movieQuote?.quote = quoteTextField.text!
//                                                self.movieQuote?.movie = movieTextField.text!
//                                                self.updateView()
                                                self.movieQuoteRef?.updateData([
                                                  "quote": quoteTextField.text!,
                                                  "movie": movieTextField.text!
                                                ])


        }
        alertController.addAction(cancelAction)
        alertController.addAction(editQuoteAction)
        present(alertController, animated: true, completion: nil)

  }


  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //updateView()
    movieQuoteListener = movieQuoteRef?.addSnapshotListener({ (documentSnapshot, error) in
      if let error = error {
        print("Error getting document: \(error)")
        return
      }
      if !documentSnapshot!.exists {
        print("This movie quote no longer exists!")
        return
      }
      self.movieQuote = MovieQuote(documentSnapshot: documentSnapshot!)
      if self.movieQuote?.author == Auth.auth().currentUser!.uid {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(self.showEditDialog))

      } else {
        self.navigationItem.rightBarButtonItem = nil
      }
      self.updateView()
    })
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    movieQuoteListener.remove()
  }


  func updateView() {
    quoteLabel.text = movieQuote?.quote
    movieLabel.text = movieQuote?.movie
  }
}
