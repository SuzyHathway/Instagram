//
//  SettingViewController.swift
//  Instagram
//
//  Created by 椎葉寛子 on 2016/03/23.
//
//

import UIKit
import Firebase
import SVProgressHUD
import ESTabBarController

class SettingViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    
    //表示名変更ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleChangeButton(sender: AnyObject) {
        
        if let name = displayNameTextField.text {
            
            //表示名が入力されていない時はHUDを出しても何もない
            if name.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("表示名を入力してください")
                return
            }
            
            //firebaseに表示名を保存する
            let usersRef = Firebase(url: CommonConst.FirebaseURL).childByAppendingPath(CommonConst.UsersPATH)
            let data = ["name": name]
            usersRef.childByAppendingPath("/\(usersRef.authData.uid)").setValue(data)
            
            //NSUserDefaultsに表示名を保存する
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setValue(name, forKey: CommonConst.DisplayNameKey)
            
            //HUDで完了をしらせる
            SVProgressHUD.showSuccessWithStatus("表示名を変更しました")
            
            //キーボードを閉じる
            view.endEditing(true)
        }
    }
    
    //ログアウトボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleLogoutButton(sender: AnyObject) {
        
        //ログアウトする
        let firebaseRef = Firebase(url: CommonConst.FirebaseURL)
        firebaseRef.unauth()
        
        //ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
        self.presentViewController(loginViewController!, animated: true, completion: nil)
        
        //ログイン画面から戻ってきた時のためにホーム画面（index=0）を選択している状態にしておく
        let tabBarController = parentViewController as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // NSUserDefaltsから表示名を取得してTextFieldに設定する
        let ud = NSUserDefaults.standardUserDefaults()
        let name = ud.objectForKey(CommonConst.DisplayNameKey) as! String
        displayNameTextField.text = name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
