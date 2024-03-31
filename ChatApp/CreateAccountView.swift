//
//  CreateAccountView.swift
//  ChatApp
//
//  Created by Gomi Kouki on 2023/08/24.
//

import UIKit

class CreateAccountView: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onImage)))
        imageView.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @objc func onImage(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        present(picker,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func onResister(_ sender: Any) {
        let name = nameField.text!
        if name.count < 3 || name.count > 10 {
            showError(massage: "名前は3文字以上10文字以内で入力してください。")
        }else {
            AuthHelper().createAccount(email: emailField.text!, password: passwordField.text!, result:{
                succes in
                if succes{
                    DatebaseHelper().resisterUserInfo(name: self.nameField.text!, image: self.imageView.image!)
                    self.dismiss(animated: true,completion: nil)
                }else{
                    self.showError(massage: "有効なメールアドレス、6文字以上のパスワードを入力してください。")
                }
            } )
        }
        
    }
    
    func showError(massage:String){
        let dialog = UIAlertController(title: "エラー", message: massage, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
        present(dialog, animated: true,completion: nil)
    }
    
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
