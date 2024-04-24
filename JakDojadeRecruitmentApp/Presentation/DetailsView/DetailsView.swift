//
//  DetailsView.swift
//  JakDojadeRecruitmentApp
//
//  Created by Jacek Stąporek on 23/04/2024.
//

import UIKit
import SnapKit
import MapKit

class DetailsView: UIViewController {
    let viewModel: DetailsViewModel
    
    lazy private var topBar: NavigationBarView = {
        let topBar = NavigationBarView()
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.showBackButton()
        topBar.backAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        return topBar
    }()
    
    lazy private var container: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    lazy private var bottomContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy private var bottomContent: CellSectionView = {
        let view = CellSectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.register(CustomAnnotation.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
        mapView.delegate = self
        mapView.showsUserLocation = true
        return mapView
    }()
    
    init(data: StationsDataModel) {
        self.viewModel = DetailsViewModel(data: data)
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.setNeedsUpdateConstraints()
        viewModel.didLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.addPin(on: mapView)
        viewModel.showRouteOn(mapView: mapView)
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(topBar)
        view.addSubview(container)
        
        container.addSubview(mapView)
        container.addSubview(bottomContainer)
        bottomContainer.addSubview(bottomContent)
        bottomContent.setupView(with: viewModel.stationData)
    }
    
    override func updateViewConstraints() {
        topBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(view)
        }
        container.snp.makeConstraints { make in
            make.top.equalTo(topBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        bottomContainer.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(container)
        }
        bottomContent.snp.makeConstraints { make in
            make.top.left.right.equalTo(bottomContainer)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        mapView.snp.makeConstraints { make in
            make.top.left.right.equalTo(container)
            make.bottom.equalTo(bottomContainer.snp.top).offset(25)
        }
        super.updateViewConstraints()
    }
}

extension DetailsView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineDashPattern = [2,2]
        renderer.strokeColor = .routeColor
        renderer.lineWidth = 1
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        let reuseIdentifier = NSStringFromClass(CustomAnnotation.self)
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation) as? CustomAnnotation
        annotationView?.canShowCallout = true
        annotationView?.setCount(viewModel.getBikesAvailable())
        return annotationView
    }
}

extension DetailsView: DetailsViewModelDelegate {
    func didGetLocation() {
        viewModel.getDistanceToDestination { [weak self] distance in
            self?.bottomContent.setupView(with: distance)
        }
    }
}
