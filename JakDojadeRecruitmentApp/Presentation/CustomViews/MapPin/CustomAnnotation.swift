//
//  CustomAnnotation.swift
//  JakDojadeRecruitmentApp
//
//  Created by Jacek Stąporek on 24/04/2024.
//

import MapKit

final class CustomAnnotation: MKAnnotationView {
    private let view = MapPinView()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 46, height: 24)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        backgroundColor = .clear
        addSubview(view)
        view.frame = bounds
    }
    
    func setCount(_ number: Int) {
        view.setCount(number)
    }
}
