//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by 椎葉寛子 on 2016/03/26.
//
//

import UIKit

class CommentTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
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
        
        // NSUserDefaultsから表示名を取得してTextFieldに設定する
        let ud = NSUserDefaults.standardUserDefaults()
        let senderName = ud.objectForKey(CommonConst.DisplayNameKey) as! String
        
        nameLabel.text = "\(senderName)"
        
        
        
        super.layoutSubviews()
    }
}