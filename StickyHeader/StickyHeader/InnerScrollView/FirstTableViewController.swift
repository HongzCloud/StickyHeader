//
//  FirstTableViewController.swift
//  StickyHeader
//
//  Created by 오킹 on 2022/02/12.
//

import UIKit

class FirstTableViewController: UIViewController, InnerScrollable {
    
    // MARK: - Properties

    var oldContentOffset: CGPoint = .zero
    @IBOutlet weak var firstTableView: UITableView!
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstTableView.dataSource = self
        self.firstTableView.delegate = self
        firstTableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    func setInnerTableViewScrollDelegate(_ delegate: InnerTableViewScrollDelegate) {
        self.innerTableViewScrollDelegate = delegate
    }
}

extension FirstTableViewController: UITableViewDataSource {
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

extension FirstTableViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta = scrollView.contentOffset.y - oldContentOffset.y

        innerTableViewScrollDelegate?.innerTableViewDidScroll(scrollView, withDistance: delta)
        
        oldContentOffset = scrollView.contentOffset
    }
}
