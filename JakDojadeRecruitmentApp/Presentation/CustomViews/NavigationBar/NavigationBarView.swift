//
//  NavigationBarView.swift
//  JakDojadeRecruitmentApp
//
//  Created by Jacek Stąporek on 23/04/2024.
//

import UIKit
import SnapKit

class NavigationBarView: UIView {
    lazy private var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backArrow"), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    var backAction: (()->())? = nil
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        setupView()
        setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonAction() {
        backAction?()
    }
    
    func setupView() {
        backgroundColor = .navbarBackground
        addSubview(backButton)
    }
    
    func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(14)
            make.left.equalTo(snp.left).offset(14)
            make.bottom.equalTo(self).offset(-14)
        }
    }
    
    func hideBackButton() {
        backButton.isHidden = true
    }
    
    func showBackButton() {
        backButton.isHidden = false
    }
}
