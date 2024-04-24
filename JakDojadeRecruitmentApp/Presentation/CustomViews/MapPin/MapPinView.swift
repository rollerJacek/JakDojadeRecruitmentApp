//
//  MapPinView.swift
//  JakDojadeRecruitmentApp
//
//  Created by Jacek Stąporek on 24/04/2024.
//

import UIKit
import SnapKit

class MapPinView: UIView {
    lazy private var container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    lazy private var countLabel: UILabel = {
        let label = UILabel()
        label.font = .manropeBold(size: 18)
        label.textColor = .mainFont
        label.text = "7"
        label.textAlignment = .center
        return label
    }()
    
    lazy var bikeImg: UIImageView = {
        let image = UIImage(named: "bike")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(container)
        container.addSubview(countLabel)
        container.addSubview(bikeImg)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        container.layer.cornerRadius = container.frame.height / 2
    }
    
    func setupView() {
        container.snp.makeConstraints { make in
            make.edges.equalTo(snp.edges)
        }
        countLabel.snp.makeConstraints { make in
            make.left.equalTo(container).offset(4)
            make.top.bottom.equalTo(container)
            make.right.equalTo(bikeImg.snp.left).offset(4)
        }
        bikeImg.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.right.equalTo(container).offset(-8)
            make.centerY.equalTo(container)
        }
    }
    
    func setCount(_ number: Int) {
        countLabel.text = "\(number)"
    }
}
