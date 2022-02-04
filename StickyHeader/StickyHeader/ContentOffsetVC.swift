//
//  contentOffsetVC.swift
//  StickyHeader
//
//  Created by 오킹 on 2022/02/02.
//

import UIKit

class ContentOffsetVC: UIViewController {

    @IBOutlet weak var StickyHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var innerTableView: UITableView!
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate!
    var oldContentOffset: CGPoint = .zero
    @IBOutlet weak var innerTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setInnerTableView()
        setMainScrollView()
    }
    
    private func setInnerTableView() {
        innerTableViewHeight.constant = mainScrollView.bounds.height - StickyHeaderHeight.constant
        innerTableViewScrollDelegate = self
        innerTableView.delegate = self
        innerTableView.dataSource = self
    }
    
    private func setMainScrollView() {
       
        mainScrollView.isScrollEnabled = false
        mainScrollView.bounces = false
    }
    
    private func maxContentOffsetY(_ scrollView: UIScrollView) -> CGFloat {
        return scrollView.contentSize.height - scrollView.bounds.height
    }
}

extension ContentOffsetVC: UITableViewDataSource {
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


extension ContentOffsetVC: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta = scrollView.contentOffset.y - oldContentOffset.y
        let maxMainScrollViewContentOffsetY = maxContentOffsetY(self.mainScrollView)

        // StickyHeader가 고정된 후 넘어가지 않도록 함
        if self.mainScrollView.contentOffset.y + delta > maxMainScrollViewContentOffsetY {
            self.mainScrollView.contentOffset.y = maxMainScrollViewContentOffsetY
        }
        else if self.mainScrollView.contentOffset.y + delta < 0 {
            self.mainScrollView.contentOffset.y = 0
            return
        }
        
        // 위로 스크롤 할 때
        if delta > 0,
           self.mainScrollView.contentOffset.y < maxMainScrollViewContentOffsetY,
           self.mainScrollView.contentOffset.y >= 0,
           self.innerTableView.contentOffset.y > 0
        {
            innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
            self.mainScrollView.contentOffset.y += delta
        }
        
        // 아래로 스크롤 할 때
        if delta < 0,
           self.mainScrollView.contentOffset.y > 0 {
  
            // 아래로 전부 스크롤 될 때 까지 innerTableView 스크롤 안되도록 함.
            if self.innerTableView.contentOffset.y < 0 {
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)

                self.mainScrollView.contentOffset.y += delta
            }
        }
        
        oldContentOffset = scrollView.contentOffset
    }
}

protocol InnerTableViewScrollDelegate: AnyObject {

    func innerTableViewDidScroll(withDistance: CGFloat)

}

extension ContentOffsetVC : InnerTableViewScrollDelegate {
   
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat) {
        
        // 스크롤 해도 움직이지 않음
        self.innerTableView.contentOffset.y -= scrollDistance
    }
}
