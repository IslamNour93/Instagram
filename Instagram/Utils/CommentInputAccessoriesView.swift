//
//  CommentInputAccessoriesView.swift
//  Instagram
//
//  Created by Islam NourEldin on 09/08/2022.
//

import UIKit

protocol CommentInputAccessoriesViewDelegate:AnyObject{
    func inputView(_ inputView: CommentInputAccessoriesView,commentText:String)
}
class CommentInputAccessoriesView: UIView {

    //MARK: - Properties
    
    weak var delegate:CommentInputAccessoriesViewDelegate?
    
    private lazy var commentTextView:CustomTextView = {
        let tv = CustomTextView()
        tv.placeholderText = "Enter comment.."
        tv.placeholderShouldBeCentered = true
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var commentButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Comment", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(hadnleCommentButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect){
    super.init(frame: frame)
        
        configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(configure), name: UITextView.textDidChangeNotification, object: nil)
        autoresizingMask = .flexibleHeight
        backgroundColor = .systemBackground
        commentTextView.delegate = self
        
        addSubview(commentButton)
        commentButton.anchor(top:topAnchor,
                             right:rightAnchor,
                             paddingRight: 8,
                             width: 70,
                             height: 50)
        
        addSubview(commentTextView)
        commentTextView.anchor(top:topAnchor,
                               left:leftAnchor,
                               bottom: safeAreaLayoutGuide.bottomAnchor,
                               right: commentButton.leftAnchor,
                               paddingLeft: 8,
                               paddingBottom: 14,
                               paddingRight: 6)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top:topAnchor,left:leftAnchor,right:rightAnchor,height: 0.5)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    
    //MARK: Helpers
    
   @objc func configure(){
        commentButton.isEnabled = !commentTextView.text.isEmpty
       if commentTextView.text.isEmpty{
           commentButton.setTitleColor(.lightGray, for: .normal)
       }else{
           commentButton.setTitleColor(.label, for: .normal)
       }
}
    
    func clearCommentText(){
        commentTextView.text = nil
        commentTextView.placeholder.isHidden = false
        configure()
    }
    //MARK: - Actions
    
    @objc func hadnleCommentButton(){
        if commentTextView.text.isEmpty{
 
        }else{
        delegate?.inputView(self, commentText: commentTextView.text)
        print("did tap button comment")
        }
    }
}

extension CommentInputAccessoriesView:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
}
