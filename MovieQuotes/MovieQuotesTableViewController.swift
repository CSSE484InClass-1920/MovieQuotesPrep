//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/28/20.
//  Copyright © 2020 David Fisher. All rights reserved.
//

import UIKit
import Firebase

class MovieQuotesTableViewController: UITableViewController {

  let movieQuoteCellIdentifier = "MovieQuoteCell"
  let showDetailSequeIdentifier = "ShowDetailSeque"
  var movieQuotes = [MovieQuote]()
  var movieQuotesRef: CollectionReference!
  var quotesListener: ListenerRegistration!
  var isShowingAllQuotes = true
  var authHandle: AuthStateDidChangeListenerHandle!

  override func viewDidLoad() {
    //    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "☰",
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu",
                                                        style: UIBarButtonItem.Style.plain,
                                                        target: self,
                                                        action: #selector(showMenu))
    //    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
    //                                                        target: self,
    //                                                        action: #selector(showAddQuoteDialog))
    navigationItem.leftBarButtonItem = editButtonItem
    //    movieQuotes.append(MovieQuote(quote: "I'll be back", movie: "The Terminator"))
    //    movieQuotes.append(MovieQuote(quote: "Yo Adrian!", movie: "Rocky"))
    movieQuotesRef = Firestore.firestore().collection("MovieQuotes")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    //    if (Auth.auth().currentUser == nil) {
    //      Auth.auth().signInAnonymously { (user, error) in
    //        if (error == nil) {
    //          print("You are now signed in using Anonymous auth.  Congrats!")
    //        }
    //      }
    //    } else {
    //      print("You are already signed in.")
    //    }

    tableView.reloadData()
    authHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
      if (Auth.auth().currentUser == nil) {
        print("Return to the login page.  No user.")
        self.navigationController?.popViewController(animated: true)
      } else {
        print("Signed in! uid=\(Auth.auth().currentUser!.uid)  Email=\(Auth.auth().currentUser!.email)")
        self.addListener()
      }
    }
  }

  func addListener() {
    if (quotesListener != nil) {
      quotesListener.remove()
    }
    var query = movieQuotesRef
      .order(by: "created", descending: true)
      .limit(to: 50)
    let currentUid = Auth.auth().currentUser!.uid
    if !isShowingAllQuotes {
      query = query.whereField("author", isEqualTo: currentUid)
    }
    quotesListener = query.addSnapshotListener() { (querySnapshot, error) in
      if let querySnapshot = querySnapshot {
        self.movieQuotes.removeAll()
        querySnapshot.documents.forEach { (documentSnapshot) in
          //          print(documentSnapshot.documentID)
          //          print(documentSnapshot.data())
          let newMovieQuote = MovieQuote(documentSnapshot: documentSnapshot)
          self.movieQuotes.append(newMovieQuote)
        }
        self.tableView.reloadData()
      } else {
        print("Error fetching snapshots: \(error!)")
        return
      }
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if (quotesListener != nil) {
      quotesListener.remove()
    }
    Auth.auth().removeStateDidChangeListener(authHandle)
  }

  @objc func showMenu() {
    let alertController = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)

    let showOnlyMyQuotesToggle = UIAlertAction(title: isShowingAllQuotes ? "Show only my quotes" : "Show all quotes",
                                               style: UIAlertAction.Style.default) { (action) -> Void in
                                                self.isShowingAllQuotes = !self.isShowingAllQuotes
                                                self.addListener()
    }
    let addQuoteAction = UIAlertAction(title: "Create a quote",
                                       style: UIAlertAction.Style.default) { (action) -> Void in
                                        self.showAddQuoteDialog()
    }
    let signOutAction = UIAlertAction(title: "Sign Out",
                                      style: UIAlertAction.Style.default) { (action) -> Void in
                                        do {
                                          try Auth.auth().signOut()
                                        } catch {
                                          print("Sign out failed: \(error)")
                                        }

    }
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: UIAlertAction.Style.cancel) {
                                      (action) -> Void in
                                      print("You pressed cancel")
    }
    alertController.addAction(showOnlyMyQuotesToggle)
    alertController.addAction(addQuoteAction)
    alertController.addAction(signOutAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
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

      //      let newMovieQuote = MovieQuote(quote: quoteTextField.text!, movie: movieTextField.text!)
      //      self.movieQuotes.insert(newMovieQuote, at: 0)
      //      self.tableView.reloadData()
      self.movieQuotesRef.addDocument(data: [
        "quote": quoteTextField.text!,
        "movie": movieTextField.text!,
        "created": Timestamp.init(),
        "author": Auth.auth().currentUser!.uid
      ])
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

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return Auth.auth().currentUser!.uid == movieQuotes[indexPath.row].author
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let movieQuoteToDelete = movieQuotes[indexPath.row]
      movieQuotesRef.document(movieQuoteToDelete.id!).delete()
      //      movieQuotes.remove(at: indexPath.row)
      tableView.reloadData()
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showDetailSequeIdentifier {

      if let indexPath = tableView.indexPathForSelectedRow {
        //        if let detailVC = segue.destination as? MovieQuoteDetailViewController {
        //          detailVC.movieQuote = movieQuotes[indexPath.row]
        //        }
        //        (segue.destination as! MovieQuoteDetailViewController).movieQuote = movieQuotes[indexPath.row]


        (segue.destination as! MovieQuoteDetailViewController).movieQuoteRef = movieQuotesRef.document(movieQuotes[indexPath.row].id!)


      }

    }
  }


}
