//
//  SecondTableViewController.swift
//  StickyHeader
//
//  Created by 오킹 on 2022/02/12.
//

import UIKit

class SecondTableViewController: UIViewController, InnerScrollable {

    // MARK: - Properties
    
    var oldContentOffset: CGPoint = .zero
    @IBOutlet weak var tableView: UITableView!
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    func setInnerTableViewScrollDelegate(_ delegate: InnerTableViewScrollDelegate) {
        self.innerTableViewScrollDelegate = delegate
    }
}

extension SecondTableViewController: UITableViewDataSource {
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

extension SecondTableViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta = scrollView.contentOffset.y - oldContentOffset.y

        innerTableViewScrollDelegate?.innerTableViewDidScroll(scrollView, withDistance: delta)
        
        oldContentOffset = scrollView.contentOffset
    }
}
