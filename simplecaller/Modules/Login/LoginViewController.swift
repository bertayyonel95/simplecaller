//
//  LoginViewController.swift
//  simplecaller
//
//  Created by Bertay Yönel on 13.08.2023.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    private var viewModel: LoginViewModelInput
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Enter user name"
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gray
        textField.placeholder = "Enter your username here"
        return textField
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Confirm", for: .normal)
        button.addTarget(self, action: #selector(confirmPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        setupViews()
    }
    
    init(viewModel: LoginViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .main)
        self.viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoginViewController {
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(button)
        
        label.snp.makeConstraints() { make in
            make.leading.trailing.equalToSuperview().inset(50)
            make.centerX.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints() { make in
            make.leading.trailing.equalToSuperview().inset(50)
            make.top.equalTo(label.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        button.snp.makeConstraints() { make in
            make.leading.trailing.equalToSuperview().inset(50)
            make.top.equalTo(textField.snp.bottom).offset(20)
        }
        
    }
    
    func showMessage(title: String, text: String, delay: Int = 0) -> Void {
        let deadlineTime = DispatchTime.now() + .seconds(delay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
            self.present(alert, animated: true)
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func confirmPressed() {
        viewModel.confirmPressed(with: textField.text ?? .empty)
    }
}

extension LoginViewController: LoginViewModelOutput {
    func login(_ usernameTaken: Bool) {
        if usernameTaken {
            showMessage(title: "Username is taken", text: .empty)
        } else {
            viewModel.navigateToHome()
        }
    }
}
