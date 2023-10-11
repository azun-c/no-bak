//
//  StatusView.swift
//  no-bak
//
//  Created by azun on 06/10/2023.
//

import UIKit

class StatusView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var checkmarkView: UIImageView = {
        let checkmark = UIImageView()
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        checkmark.image = UIImage(systemName: "checkmark.circle.fill")
        checkmark.tintColor = .green
        checkmark.isHidden = true
        return checkmark
    }()
    
    func configure(with message: String) {
        statusLabel.text = message
    }
    
    func setDone() {
        checkmarkView.isHidden = false
        
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
    }
}

// MARK: Private

private extension StatusView {
    enum Constants {
        static let padding = CGFloat(20)
        static let indicatorHeight = CGFloat(20)
    }
    func setupUI() {
        setupLabel()
        setupLoadingIndicator()
        setupDoneIndicator()
    }
    
    func setupLabel() {
        addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            statusLabel.topAnchor.constraint(equalTo: topAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setupLoadingIndicator() {
        addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: Constants.padding),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: Constants.indicatorHeight),
            indicatorView.heightAnchor.constraint(equalTo: indicatorView.widthAnchor),
            indicatorView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constants.padding)
        ])
    }
    
    func setupDoneIndicator() {
        addSubview(checkmarkView)
        NSLayoutConstraint.activate([
            checkmarkView.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: Constants.padding),
            checkmarkView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkView.widthAnchor.constraint(equalToConstant: Constants.indicatorHeight),
            checkmarkView.heightAnchor.constraint(equalTo: checkmarkView.widthAnchor),
            checkmarkView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constants.padding)
        ])
    }
}
