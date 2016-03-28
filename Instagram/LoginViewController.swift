//
//  ViewController.swift
//  Instagram
//
//  Created by 椎葉寛子 on 2016/03/23.
//
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {


    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    var firebaseRef: Firebase!
    
    //ログインボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleLoginButton(sender: AnyObject) {
        
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            
            //アドレスとパスワード名のいずれかでも入力されていないときはHUDを出して何もしない
            if address.characters.isEmpty || password.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("必要項目を入力してください")
                
                return
            }
            
            //処理を表示
            SVProgressHUD.show()
            
            
            firebaseRef.authUser(address, password:  password, withCompletionBlock:
                {error, authData in
                
                if error != nil {
                    //エラー表示
                    SVProgressHUD.showErrorWithStatus("エラー")
                    
                }else{
                    
                    //fireBaseからログインしたユーザーの表示名を取得してNSUserDefaltsに保存する
                    let usersRef = self.firebaseRef.childByAppendingPath(CommonConst.UsersPATH)
                    let uidRef = usersRef.childByAppendingPath(authData.uid)
                    uidRef.observeSingleEventOfType(FEventType.Value, withBlock: { snapshot in

                        
                        if let displayName = snapshot.value.objectForKey("name") as? String {
                        self.setDisplayName(displayName)
                    }
                        
                    //HUDを消す
                    SVProgressHUD.dismiss()
                        
                    //画面を閉じる
                        self.dismissViewControllerAnimated(true, completion: nil)})
                    }
                    
            })
        }
    }

    
    
    //アカウント作成ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCreateAcountButton(sender: AnyObject) {
        
        //３つの項目の入力は必須。address.characters.countで文字数を取得する
        //isEmptyを使って文字が入力されているかを判断する
        if let address = mailAddressTextField.text, let password = passwordTextField.text,
            let displayName = displayNameTextField.text {
                // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない = ruturn
                if address.characters.isEmpty || password.characters.isEmpty
                    || displayName.characters.isEmpty {
                        SVProgressHUD.showErrorWithStatus("必要項目を入力してください")
                        
                        return
                }
                
                //処理中を表示
                SVProgressHUD.show()
                
                //firebaseのアカウントの作成
                //入力した３項目を与えてメソッドを呼び出す
                firebaseRef.createUser(address, password: password, withValueCompletionBlock: { error, result in
                    
                    //エラーが無ければログイン処理を行う
                    if error != nil {
                        //エラー表示
                        SVProgressHUD.showErrorWithStatus("エラー")
                    } else {
                        
                        // ユーザーを作成できたらそのままログインする
                        self.firebaseRef.authUser(address, password: password, withCompletionBlock:  { error, authData in
                            if error != nil {
                                //エラー表示
                                SVProgressHUD.showErrorWithStatus("エラー")
                            } else {
                                // Firebaseに表示名を保存する
                                let usersRef = self.firebaseRef.childByAppendingPath(CommonConst.UsersPATH)
                                let data = ["name": displayName]
                                usersRef.childByAppendingPath("/\(authData.uid)").setValue(data)
                                
                                // NSUserDefaultsに表示名を保存する
                                self.setDisplayName(displayName)
                                
                                // HUDを消す
                                SVProgressHUD.dismiss()
                                
                                // 画面を閉じる
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        })
                    }
                })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebaseを初期化する
        firebaseRef = Firebase(url: CommonConst.FirebaseURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // NSUserDefaultsに表示名を保存する
    func setDisplayName(name: String) {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setValue(name, forKey: CommonConst.DisplayNameKey)
        ud.synchronize()
    }


}

