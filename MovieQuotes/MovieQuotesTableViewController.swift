//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/28/20.
//  Copyright © 2020 David Fisher. All rights reserved.
//

import UIKit

class MovieQuotesTableViewController: UITableViewController {

  let movieQuoteCellIdentifier = "MovieQuoteCell"
  let showDetailSequeIdentifier = "ShowDetailSeque"
  var movieQuotes = [MovieQuote]()


  override func viewDidLoad() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: #selector(showAddQuoteDialog))
    navigationItem.leftBarButtonItem = editButtonItem
    movieQuotes.append(MovieQuote(quote: "I'll be back", movie: "The Terminator"))
    movieQuotes.append(MovieQuote(quote: "Yo Adrian!", movie: "Rocky"))
  }

  @objc func showAddQuoteDialog() {
    let alertController = UIAlertController(title: "Create a new movie quote",
                                            message: "",
                                            preferredStyle: .alert)
    alertController.addTextField { (textField) -> Void in
      textField.placeholder = "Quote"
    }
    alertController.addTextField { (textField) -> Void in
      textField.placeholder = "Movie title"
    }
    let createQuoteAction = UIAlertAction(title: "Create Quote", style: UIAlertAction.Style.default) { (action) -> Void in
      let quoteTextField = alertController.textFields![0] as UITextField
      let movieTextField = alertController.textFields![1] as UITextField
      //      print("Quote: \(quoteTextField.text!)")
      //      print("Movie: \(movieTextField.text!)")
      let newMovieQuote = MovieQuote(quote: quoteTextField.text!, movie: movieTextField.text!)
      self.movieQuotes.insert(newMovieQuote, at: 0)
      self.tableView.reloadData()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
      (action) -> Void in
      print("You pressed cancel")
    }
    alertController.addAction(cancelAction)
    alertController.addAction(createQuoteAction)
    present(alertController, animated: true, completion: nil)
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: movieQuoteCellIdentifier,
                                             for: indexPath)
    let movieQuote = movieQuotes[indexPath.row]
    cell.textLabel?.text = movieQuote.quote
    cell.detailTextLabel?.text = movieQuote.movie
    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    movieQuotes.count
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      movieQuotes.remove(at: indexPath.row)
      tableView.reloadData()
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showDetailSequeIdentifier {

      if let indexPath = tableView.indexPathForSelectedRow {
        //        if let detailVC = segue.destination as? MovieQuoteDetailViewController {
        //          detailVC.movieQuote = movieQuotes[indexPath.row]
        //        }
        (segue.destination as! MovieQuoteDetailViewController).movieQuote = movieQuotes[indexPath.row]
      }

    }
  }


}
