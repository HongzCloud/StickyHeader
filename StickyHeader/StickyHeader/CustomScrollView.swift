//
//  CustomScrollView.swift
//  StickyHeader
//
//  Created by 오킹 on 2022/01/28.
//

import UIKit

class CustomScrollView: UIScrollView {

    @IBOutlet weak var customTableView: CustomTableView!
    @IBOutlet weak var button: UIButton!
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
         let hitView = super.hitTest(point, with: event)

         // 서브 뷰가 터치되지 않았으면 nil을 반환(하위에 있는 view로 touch event넘김), 서브 뷰가 터치되었으면 하위뷰인 hitView를 반환
        print(hitView.self)

        if hitView is UIButton {
            return button
        }
         return  hitView
     }
}
