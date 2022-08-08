//
//  CustomTextView.swift
//  Instagram
//
//  Created by Islam NourEldin on 07/08/2022.
//

import UIKit

class CustomTextView: UITextView {

    var placeholderText:String?{
        didSet{
            placeholder.text = placeholderText
        }
    }
    
    private let placeholder:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()

    override init(frame: CGRect, textContainer: NSTextContainer?){
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholder)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
        placeholder.anchor(top:topAnchor,left:leftAnchor,paddingTop: 4,paddingLeft: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func textDidChange(){
        
        placeholder.isHidden = !text.isEmpty
    }
}
