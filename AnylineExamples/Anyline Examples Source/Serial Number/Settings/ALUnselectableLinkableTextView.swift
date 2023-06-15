//
//  ALUnselectableLinkableTextView.swift
//  AnylineExamples
//
//  Created by Angela Brett on 13.10.20.
//

import UIKit

@objc
class ALUnselectableLinkableTextView : UITextView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }

    @objc
    init(tapDelegate: ALUnselectableLinkableTextViewDelegate? = nil) {
        super.init(frame: .zero, textContainer: nil)

        if let _ = tapDelegate {
            self.tapDelegate = tapDelegate
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSelf)))
        }
    }

    @objc weak var tapDelegate: ALUnselectableLinkableTextViewDelegate?

    @objc func didTapSelf(gesture: UITapGestureRecognizer) {
        // and it should be == self as well
        guard let textView = gesture.view as? ALUnselectableLinkableTextView else {
            return
        }

        let layoutManager = textView.layoutManager
        var loc = gesture.location(in: textView)
        loc.x -= textView.textContainerInset.left
        loc.y -= textView.textContainerInset.top

        let characterIdx = layoutManager.characterIndex(for: loc,
                                                        in: textView.textContainer,
                                                        fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIdx < textView.textStorage.length {
            var range: NSRange? = NSMakeRange(0, 1)
            if let urlString = textView.attributedText.attribute(.link, at: characterIdx, effectiveRange: &range!) as? String {
                tapDelegate?.textView(textView, tappedLinkWithURLString: urlString)
            } else {
                tapDelegate?.textViewTappedOutsideOfLink(textView)
            }
        }
    }
}

@objc
protocol ALUnselectableLinkableTextViewDelegate: AnyObject {

    // handle URL taps
    func textView(_ textView: ALUnselectableLinkableTextView, tappedLinkWithURLString urlString: String)

    func textViewTappedOutsideOfLink(_ textView: ALUnselectableLinkableTextView)
}
