//
//  MainViewTableViewCell.swift
//  JakDojadeRecruitmentApp
//
//  Created by Jacek Stąporek on 23/04/2024.
//

import UIKit
import SnapKit

class MainViewTableViewCell: UITableViewCell {
    lazy private var container: UIView = {
        let view = UIView()
        view.backgroundColor = .cellBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 16
        view.layer.shadowOffset = CGSize(width: 0, height: -30)
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy private var content: CellSectionView = {
        let view = CellSectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Main cell view shadow fix
    override func layoutSubviews() {
        super.layoutSubviews()
        var r = container.bounds
        r.origin.y += 40
        container.layer.shadowPath = UIBezierPath(roundedRect: r, cornerRadius: 16).cgPath
    }
    
    func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(container)
        container.addSubview(content)
    }
    
    func setupConstraints() {
        container.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
            make.top.equalTo(self).offset(4)
            make.bottom.equalTo(self).offset(-4)
            
            make.edges.equalTo(content)
        }
    }
    
    func setupView(with data: StationsDataModel) {
        content.setupView(with: data)
    }
    
    func setupView(with distance: String) {
        content.setupView(with: distance)
    }
}
