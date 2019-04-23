//
//  ViewController.swift
//  QuoteOfTheDay
//
//  Created by Hameed Abdullah on 4/19/19.
//  Copyright © 2019 Hameed Abdullah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var quotes: [Quote] = [Quote]()
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        fetchQuoteJson()
    }
    
    
    func fetchQuoteJson() {

        if let url:URL = URL(string: "https://quotes.rest/qod.json") {

            URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in

                if let err = error {
                    print("error = \(err)")
                    return
                }

                if let data: Data = data {

                    let dict: [String: Any]

                    do {
                        try dict = JSONSerialization.jsonObject(with: data) as! [String: Any]
                    } catch {
                        fatalError("could not create dictionary: \(error)");
                    }

                    print("dict.count \(dict.count)")
                    dict.forEach {print("\t\($0.key): \($0.value)");}

                    let quotesJson: [String: Any] = dict["contents"] as! [String: Any]

                    let quotes2: [[String: Any]] = quotesJson["quotes"] as! [[String: Any]]

                    print("quotes2.count = \(quotes2.count)")
                    
                    for q in quotes2 {
                        let author: String = q["author"] as! String
                        print("author = \(author)")
                        
                        let quotOfTheDay: String = q["quote"] as! String
                        print("quotOfTheDay = \(quotOfTheDay)")
                        
                        let category: String = q["category"] as! String
                        print("category = \(category)")
                        
                        let date: String = q["date"] as! String
                        print("date = \(date)")
                        
                        self.quotes.append(Quote(quote: quotOfTheDay, author: author, date: date, category: category))
                        
                    }
                    
                    //only main thread can write to screen
                    DispatchQueue.main.async {
                        self.quotes.forEach({ (quote) in
                            self.quoteLabel.text = quote.quote
                            self.authorLabel.text = quote.author
                            self.categoryLabel.text = quote.category
                            self.dateLabel.text = quote.date
                        })
                    }

                }


                }.resume()

        }


    }



}


//extension ViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return quotes.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? QuoteTableViewCell {
//            let obj = quotes[indexPath.row]
//            
//            cell.updateUI(quote: obj)
//            
//            return cell
//            
//        } else {
//            return UITableViewCell()
//        }
//    }
//    
//    
//    
//}
