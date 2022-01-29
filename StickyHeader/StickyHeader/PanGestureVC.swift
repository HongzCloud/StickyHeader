//
//  PanGestureVC.swift
//  StickyHeader
//
//  Created by 오킹 on 2022/01/27.
//

import UIKit

class PanGestureVC: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stickyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.backgroundColor = .red
        tableView.isScrollEnabled = false
        tableViewHeight.constant = scrollView.bounds.height - stickyViewHeight.constant
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        panGesture.delegate = self
        
        scrollView.addGestureRecognizer(panGesture)
        scrollView.isScrollEnabled = false
    }
    
    // MARK: - Private
    
    private func maxContentOffsetY(_ scrollView: UIScrollView) -> CGFloat {
        return scrollView.contentSize.height - scrollView.bounds.height
    }
    
    // MARK: - PanAction
    
    @objc func panAction(_ sender: UIPanGestureRecognizer) {
        let maxScrOffY = maxContentOffsetY(scrollView)
        let scrOffY = scrollView.contentOffset.y
        let maxTabOffY = maxContentOffsetY(tableView)
        let tabOffY = tableView.contentOffset.y
        let velocityY = sender.velocity(in: scrollView).y / 80
       
        // 스크롤뷰 CotentOffset이 0 일 때 아래쪽으로 스크롤 하려 할 때
        if scrOffY - velocityY < 0 {
            print("A")
            scrollView.contentOffset.y = 0
        }
        // StickyView가 위쪽에 고정되었을 때
        else if scrOffY - velocityY > maxScrOffY {
            print("B")
            scrollView.contentOffset.y = maxScrOffY
            tableView.contentOffset.y = (tabOffY - velocityY > maxTabOffY) ? maxTabOffY : tabOffY - velocityY
        }
        // StickyView가 위쪽에 고정되기 전까지 스크롤
        else {
            // 아래로 스크롤
            if velocityY < 0 {
                scrollView.contentOffset.y = scrOffY - velocityY
            }
            // 위로 스크롤
            else {
                // 테이블뷰 CotentOffset이 0 일 때 위쪽으로 스크롤 하려 할 때
                if (tabOffY - velocityY < 0) {
                    tableView.contentOffset.y = 0
                    scrollView.contentOffset.y = scrOffY - velocityY
                }
                // 테이블뷰 CotentOffset이 0 일 때 아래쪽으로 스크롤 하려 할 때
                else {
                    tableView.contentOffset.y = tabOffY - velocityY
                }
            }
        }
    }
}

extension PanGestureVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
}

extension PanGestureVC: UIGestureRecognizerDelegate {
    
    // scrollView gesture 중첩 적용 허용
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
