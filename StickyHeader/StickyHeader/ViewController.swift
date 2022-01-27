//
//  ViewController.swift
//  StickyHeader
//
//  Created by 오킹 on 2022/01/26.
//

import UIKit

class ViewController: UIViewController, Stop {
    func stop() {
        scrollView.isScrollEnabled = true
        tableView.isScrollEnabled = false
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var stikcyView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
  
    var tableViewDelegate = A()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelegate.stop = self
        // Do any additional setup after loading the view.
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.tableView.dataSource = self
        
        tableView.isScrollEnabled = false
        scrollView.delegate = self
        tableView.delegate = tableViewDelegate
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .darkGray
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        print(stikcyView.bounds, "dd")
        if scrollView.contentOffset.y == 175 {
            scrollView.isScrollEnabled = false
            tableView.isScrollEnabled = true
        } else {
           
        }
        
        
    }
}

class A: NSObject, UITableViewDelegate {
    var stop: Stop!
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        if scrollView.contentOffset.y <= 0 {
            stop.stop()
        }
        
    }
}

protocol Stop {
    func stop()
}
