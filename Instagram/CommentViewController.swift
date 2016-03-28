//
//  CommentViewController.swift
//  Instagram
//
//  Created by 椎葉寛子 on 2016/03/25.
//
//

import UIKit
import Firebase

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    var firebaseRef: Firebase!
    var postData: PostData!
    
    
    //oberveが登録されているかを判断
    var isObserving: Bool  = false
    
    
    override func viewWillAppear(animated: Bool) {
        // Viewの表示時にキーボード表示・非表示を監視するObserverを登録する
        super.viewWillAppear(animated)
        if(!isObserving) {
            let notification = NSNotificationCenter.defaultCenter()
            notification.addObserver(self, selector: "keyboardWillShow:"
                , name: UIKeyboardWillShowNotification, object: nil)
            notification.addObserver(self, selector: "keyboardWillHide:"
                , name: UIKeyboardWillHideNotification, object: nil)
            isObserving = true
        }
    }
    override func viewWillDisappear(animated: Bool) {
        // Viewの表示時にキーボード表示・非表示時を監視していたObserverを解放する
        super.viewWillDisappear(animated)
        if(isObserving) {
            let notification = NSNotificationCenter.defaultCenter()
            notification.removeObserver(self)
            notification.removeObserver(self
                , name: UIKeyboardWillShowNotification, object: nil)
            notification.removeObserver(self
                , name: UIKeyboardWillHideNotification, object: nil)
            isObserving = false
        }
    }
    
    func keyboardWillShow(notification: NSNotification?) {
        // キーボード表示時の動作をここに記述する
        let rect = (notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration:NSTimeInterval = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey]as! Double
        UIView.animateWithDuration(duration, animations: {
            let transform = CGAffineTransformMakeTranslation(0, -rect.size.height)
            self.view.transform = transform
            },completion:nil)
    }
    
    func keyboardWillHide(notification: NSNotification?) {
        // キーボード消滅時の動作をここに記述する
        let duration = (notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double)
        UIView.animateWithDuration(duration, animations:{
            self.view.transform = CGAffineTransformIdentity
            },
            completion:nil)
    }
    
    @IBAction func sendButton(sender: AnyObject) {
        
        // NSUserDefaultsから表示名を取得してTextFieldに設定する
        let ud = NSUserDefaults.standardUserDefaults()
        let senderName = ud.objectForKey(CommonConst.DisplayNameKey) as! String
        
        postData.comments.append("\(senderName) : \(textView.text)")
        
        textView.text = ""
        self.view.endEditing(true)
        tableView.reloadData()
        
        let imageString = postData.imageString
        let name = postData.name
        let caption = postData.caption
        let time = (postData.date?.timeIntervalSinceReferenceDate)! as NSTimeInterval
        let likes = postData.likes
        let comments = postData.comments
        
        //辞書を利用してFirebaseに保存する
        let post = ["caption": caption!, "image": imageString!, "name":name!, "time": time, "likes": likes, "comments": comments]
        let postRef = Firebase(url: CommonConst.FirebaseURL).childByAppendingPath(CommonConst.PostPATH)
        postRef.childByAppendingPath(postData.id).setValue(post)
    }
    
    
    
    
    //テーブルのデータ数を返す
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.comments.count
    }
    
    
    // 各セルの内容を返す
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        //Cellに値を設定する
        cell.textLabel?.text = "\(postData.comments[indexPath.row])"
        
        return cell
    
    }

    
    @IBAction func buckPage(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
