//
//  ViewController.swift
//  RealmInvalidGuardStorage
//
//  Created by Bondar Yaroslav on 27/02/2017.
//  Copyright © 2017 Bondar Yaroslav. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UITableViewController {
    
    
    let service = EventService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// !!! CRASH !!! Realm accessed from incorrect thread
        for i in 0..<10000 {
            _ = service.save(Ev(id: i)).then { _ in
                print(i)
            }
        }
        
    }
    
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return service.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        
//        _ = service.get(at: indexPath.row).then { (event) -> Void in
//            cell.textLabel?.text = event.title
//            cell.detailTextLabel?.text = String(event.portfolioId)
//        }
//        
//        return cell
//    }
}
