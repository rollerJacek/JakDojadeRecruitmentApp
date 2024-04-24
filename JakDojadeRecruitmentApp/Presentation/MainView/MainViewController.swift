//
//  MainViewController.swift
//  JakDojadeRecruitmentApp
//
//  Created by Jacek Stąporek on 23/04/2024.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    let viewModel = MainViewModel()
    
    lazy private var topBar: NavigationBarView = {
        let topBar = NavigationBarView()
        topBar.hideBackButton()
        return topBar
    }()
    
    lazy private var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy private var indicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 40, right: 0)
        tableView.register(MainViewTableViewCell.self, forCellReuseIdentifier: CellId.mainView)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.delegate = self
        viewModel.didLoad()
        view.setNeedsUpdateConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(topBar)
        view.addSubview(indicator)
        view.addSubview(container)
        
        container.addSubview(tableView)
        indicator.startAnimating()
        container.isHidden = true
    }
    
    override func updateViewConstraints() {
        topBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(view)
        }
        indicator.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        container.snp.makeConstraints { make in
            make.top.equalTo(topBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(container)
        }
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }
    
    func updateLayout() -> Void {
        for c in tableView.visibleCells {
            tableView.bringSubviewToFront(c)
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stations?.data.stations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId.mainView, for: indexPath) as! MainViewTableViewCell
        if let data = viewModel.stations?.data.stations[indexPath.row] {
            cell.setupView(with: data)
            if let lat = data.lat, let lon = data.lon {
                viewModel.getDistanceToDestination(lat: lat, lon: lon) { distance in
                    cell.setupView(with: distance)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModel.stations?.data.stations[indexPath.row] else { return }
        let vc = DetailsView(data: data)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateLayout()
    }
}

extension MainViewController: MainViewModelDelegate {
    func didFetchData() {
        tableView.reloadData()
        container.alpha = 0
        container.isHidden = false
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.indicator.alpha = 0
            self?.container.alpha = 1
        } completion: { [weak self] _ in
            guard let self = self, self.indicator.isAnimating else { return }
            self.indicator.stopAnimating()
            self.indicator.removeFromSuperview()
        }
    }
    
    func didGetLocation() {
        tableView.reloadData()
    }
}
