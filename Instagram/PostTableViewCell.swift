//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 椎葉寛子 on 2016/03/23.
//
//


import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentLabel: UILabel!
    
    var postData: PostData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // 表示されるときに呼ばれるメソッドをオーバーライドしてデータをUIに反映する
    override func layoutSubviews() {
        
        postImageView.image = postData!.image
        captionLabel.text = "\(postData!.name!) : \(postData!.caption!)"
        
        let likeNumber = postData!.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let commentNumber = postData!.comments.count
        commentLabel.text = "\(commentNumber)"
        
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.stringFromDate(postData!.date!)
        dateLabel.text = dateString
        
        if postData!.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            likeButton.setImage(buttonImage, forState: UIControlState.Normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            likeButton.setImage(buttonImage, forState: UIControlState.Normal)
        }
        
        //****修正箇所＊＊＊＊＊
        //コメントがあればテキストに反映させる
        if postData!.comments.count != 0 {
            commentTextView.text = ""
            
        let num = postData!.comments.count - 1
        for i in 0...num {
            commentTextView.text = commentTextView.text + "\n\(postData!.comments [i])"
        }
        }
        
        super.layoutSubviews()
    }
}