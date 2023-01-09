//
//  ALLeftCheckmarkCell.swift
//  AnylineExamples
//
//  Created by Angela Brett on 15.07.20.
//

import UIKit

// alas, there is not standard way of having a checkmark on the left, even though it's done in settings, so we fake it with an image view showing our own checkmark
class ALLeftCheckmarkCell : UITableViewCell {
    
    public var rowWasChecked: (UITableViewCell) -> () = { _ in }
    
    lazy private var tapGestureRecognizer:UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkMe(tapGestureRecognizer:)))
        //without this line, we don't get the action
        gestureRecognizer.cancelsTouchesInView = false
        return gestureRecognizer
    }()
    
    var isChecked:Bool = false {
        didSet {
            imageView?.tintColor = self.tintColor
            imageView?.image = UIImage.init(named: isChecked ? "ic_done_white_48pt" : "unchecked")?.withRenderingMode(.alwaysTemplate)
            if (!isChecked) {
                imageView?.isUserInteractionEnabled = true
                imageView?.addGestureRecognizer(tapGestureRecognizer)
            } else {
                imageView?.removeGestureRecognizer(tapGestureRecognizer)
                imageView?.isUserInteractionEnabled = false
            }
        }
    }

    @objc func checkMe(tapGestureRecognizer: UITapGestureRecognizer) {
        self.isChecked = true
        rowWasChecked(self)
    }
}
