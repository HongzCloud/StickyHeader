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
 
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate!
    var oldContentOffset: CGPoint = .zero
    
    // MARK: - Programatic UI Properties
    
    lazy var VCArray: [UIViewController] = {
        return [self.VCInstance(name: "FirstTableViewController"),
                self.VCInstance(name: "SecondTableViewController")]
    }()
    
    @IBOutlet weak var containerView: UIView!
    var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setInnerTableView()
        setMainScrollView()
    }
    
    private func VCInstance(name: String) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: name) as? InnerScrollable
        vc?.setInnerTableViewScrollDelegate(self)
        
        return vc ?? UIViewController() 
    }
    
    private func setInnerTableView() {
        if let firstVC = VCArray.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
               }
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.frame = containerView.bounds
        pageViewController.didMove(toParent: self)
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

extension ContentOffsetVC : InnerTableViewScrollDelegate {
    
    func innerTableViewDidScroll(_ scrollView: UIScrollView, withDistance: CGFloat) {

       // let delta = scrollView.contentOffset.y - oldContentOffset.y
        let maxMainScrollViewContentOffsetY = maxContentOffsetY(self.mainScrollView)

        // StickyHeader가 고정된 후 넘어가지 않도록 함
        if self.mainScrollView.contentOffset.y + withDistance > maxMainScrollViewContentOffsetY {
            self.mainScrollView.contentOffset.y = maxMainScrollViewContentOffsetY
        }
        else if self.mainScrollView.contentOffset.y + withDistance < 0 {
            self.mainScrollView.contentOffset.y = 0
            return
        }
        
        // 위로 스크롤 할 때
        if withDistance > 0,
           self.mainScrollView.contentOffset.y < maxMainScrollViewContentOffsetY,
           self.mainScrollView.contentOffset.y >= 0,
           scrollView.contentOffset.y > 0
        {
            // 스크롤 해도 움직이지 않음
            scrollView.contentOffset.y -= withDistance
            self.mainScrollView.contentOffset.y += withDistance
        }
        
        // 아래로 스크롤 할 때
        if withDistance < 0,
           self.mainScrollView.contentOffset.y > 0 {
  
            // 아래로 전부 스크롤 될 때 까지 innerTableView 스크롤 안되도록 함.
            if scrollView.contentOffset.y < 0 {
                // 스크롤 해도 움직이지 않음
                scrollView.contentOffset.y -= withDistance

                self.mainScrollView.contentOffset.y += withDistance
            }
        }
        
        oldContentOffset = scrollView.contentOffset
    }
}

extension ContentOffsetVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

            guard let viewControllerIndex = VCArray.firstIndex(of: viewController) else { return nil }

            let previousIndex = viewControllerIndex - 1
                    print(previousIndex)

            if previousIndex < 0 {
                return VCArray.last
            } else {
                return VCArray[previousIndex]
            }
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = VCArray.firstIndex(of: viewController) else { return nil }
            let nextIndex = viewControllerIndex + 1

            if nextIndex >= VCArray.count {
                return VCArray.first
            } else {
                return VCArray[nextIndex]
            }
       }
}
