//
//  CellSectionView.swift
//  JakDojadeRecruitmentApp
//
//  Created by Jacek Stąporek on 23/04/2024.
//

import UIKit
import SnapKit

class CellSectionView: UIView {
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .manropeBold(size: 24)
        label.textColor = .mainFont
        label.text = "047 Ofiar Dąbia"
        return label
    }()
    
    lazy private var descriptionContainer: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .cellBackground
        view.spacing = 1
        view.axis = .horizontal
        return view
    }()
    
    lazy private var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .manropeBold(size: 12)
        label.textColor = .mainFont
        label.text = "-m"
        return label
    }()
    
    lazy private var dotLabel: UILabel = {
        let label = UILabel()
        label.font = .manropeRegular(size: 12)
        label.textColor = .mainFont
        label.text = "·"
        return label
    }()
    
    lazy private var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .manropeRegular(size: 12)
        label.textColor = .mainFont
        label.text = "Aleja Pokoju 16, Kraków"
        return label
    }()
    
    lazy private var bottomSectionContainer: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cellBackground
        view.spacing = 0
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    
    lazy private var leftSectionContainer: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .cellBackground
        view.spacing = 1
        view.axis = .vertical
        view.alignment = .center
        return view
    }()
    
    lazy private var bikeImg: UIImageView = {
        let image = UIImage(named: "bike")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy private var countBikesLabel: UILabel = {
        let label = UILabel()
        label.font = .manropeBold(size: 44)
        label.textColor = .contentPositive
        label.text = "7"
        return label
    }()
    
    lazy private var bikesAvailableLabel: UILabel = {
        let label = UILabel()
        label.font = .manropeRegular(size: 12)
        label.textColor = .mainFont
        label.text = "Bikes available"
        return label
    }()
    
    lazy private var rightSectionContainer: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .cellBackground
        view.spacing = 1
        view.axis = .vertical
        view.alignment = .center
        return view
    }()
    
    lazy private var padlockImg: UIImageView = {
        let image = UIImage(named: "padlock")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy private var countPlacesLabel: UILabel = {
        let label = UILabel()
        label.font = .manropeBold(size: 44)
        label.textColor = .mainFont
        label.text = "20"
        return label
    }()
    
    lazy private var placesAvailableLabel: UILabel = {
        let label = UILabel()
        label.font = .manropeRegular(size: 12)
        label.textColor = .mainFont
        label.text = "Places available"
        return label
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
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
    
    func setupView() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(descriptionContainer)
        addSubview(bottomSectionContainer)
        
        descriptionContainer.addArrangedSubview(distanceLabel)
        descriptionContainer.addArrangedSubview(dotLabel)
        descriptionContainer.addArrangedSubview(addressLabel)
        
        bottomSectionContainer.addArrangedSubview(leftSectionContainer)
        bottomSectionContainer.addArrangedSubview(rightSectionContainer)
        
        leftSectionContainer.addArrangedSubview(bikeImg)
        leftSectionContainer.addArrangedSubview(countBikesLabel)
        leftSectionContainer.addArrangedSubview(bikesAvailableLabel)
        
        rightSectionContainer.addArrangedSubview(padlockImg)
        rightSectionContainer.addArrangedSubview(countPlacesLabel)
        rightSectionContainer.addArrangedSubview(placesAvailableLabel)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(self).offset(16)
            make.right.lessThanOrEqualTo(self).offset(16)
        }
        
        descriptionContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(titleLabel)
        }
        
        bottomSectionContainer.snp.makeConstraints { make in
            make.top.equalTo(descriptionContainer.snp.bottom).offset(20)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
            make.bottom.equalTo(self).offset(-16)
        }
    }
    
    func setupView(with data: StationsDataModel) {
        titleLabel.text = data.name
        addressLabel.text = data.address
        countBikesLabel.text = "\(data.bikesAvailable ?? 0)"
        countPlacesLabel.text = "\(data.dockAvailable ?? 0)"
    }
    
    func setupView(with distance: String) {
        distanceLabel.text = distance
    }
}
