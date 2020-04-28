//
//  MovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/28/20.
//  Copyright © 2020 David Fisher. All rights reserved.
//

import UIKit

class MovieQuoteDetailViewController: UIViewController {
  @IBOutlet weak var quoteLabel: UILabel!
  @IBOutlet weak var movieLabel: UILabel!
  var movieQuote: MovieQuote?

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                        target: self,
                                                        action: #selector(showEditDialog))
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

                                                self.movieQuote?.quote = quoteTextField.text!
                                                self.movieQuote?.movie = movieTextField.text!
                                                self.updateView()



        }
        alertController.addAction(cancelAction)
        alertController.addAction(editQuoteAction)
        present(alertController, animated: true, completion: nil)

  }


  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateView()
  }

  func updateView() {
    quoteLabel.text = movieQuote?.quote
    movieLabel.text = movieQuote?.movie
  }
}
