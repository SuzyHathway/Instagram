//
//  ViewController.swift
//  Instagram
//
//  Created by 椎葉寛子 on 2016/03/23.
//
//

import UIKit
import ESTabBarController
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Firebaseを初期化して認証情報を取得する
        let firebaseRef = Firebase(url: CommonConst.FirebaseURL)
        let authData = firebaseRef.authData
        
        //認証情報＝authDataが無ければログインしていない
        if authData == nil {
            //ログインしていなければログイン画面を表示する
            //ViewWillAppear内でpresentViewControllerを呼び出しても表示されないメッソドが終了してから呼ばれるようにする
            dispatch_async(dispatch_get_main_queue()) {
                let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(loginViewController!, animated: true, completion: nil)
            }
        } else {
            //authDataがnilでない場合は'setupTab'メソッドを呼び出してタブを表示させる
            setupTab()
        }
        
        
    }
    
    func setupTab(){
        //画像のファイル名を指定してESTabBarControllerを作成する
        let tabBarController = ESTabBarController(tabIconNames: ["home","camera","setting"])
        
        //背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        
        //作成したESTabBarControllerの親をViewController(=self)に追加する
        addChildViewController(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.view.frame = view.bounds
        tabBarController.didMoveToParentViewController(self)
        
        // タブをタップした時に表示するViewControllerを設定する
        let homeViewController = storyboard?.instantiateViewControllerWithIdentifier("Home")
        let settingViewController = storyboard?.instantiateViewControllerWithIdentifier("Setting")
        
        tabBarController.setViewController(homeViewController, atIndex: 0)
        tabBarController.setViewController(settingViewController, atIndex: 2)
        
        //真ん中のタブはボタンとして扱う
        tabBarController.highlightButtonAtIndex(1)
        tabBarController.setAction({
            
            //ボタンが押されたらImageViewControllerをモーダルで表示する
            let imageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageSelect")
                self.presentViewController(imageViewController!, animated: true, completion: nil)
                },atIndex: 1)
    }

}
