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
  var movieQuotes = [MovieQuote]()


  override func viewDidLoad() {
    movieQuotes.append(MovieQuote(quote: "I'll be back", movie: "The Terminator"))
    movieQuotes.append(MovieQuote(quote: "Yo Adrian!", movie: "Rocky"))
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

}
