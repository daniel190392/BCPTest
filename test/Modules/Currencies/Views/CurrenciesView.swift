//
//  CurrenciesView.swift
//  test
//
//  Created by Daniel Salhuana on 4/7/20.
//  Copyright © 2020 Daniel Salhuana. All rights reserved.
//

import UIKit

class CurrenciesView: UIView {

    var imageViewLogo = UIImageView()
    var tableView: UITableView
    
    struct ViewTraits {
        static let horizontalMargin: CGFloat = 20.0
        static let verticalMargin: CGFloat = 20.0
    }
    
    override init(frame: CGRect) {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        super.init(frame: frame)
        
        setupComponents()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponents() {
        backgroundColor = .white
        
        imageViewLogo.image = UIImage(named: "BCP")
        imageViewLogo.contentMode = .scaleAspectFit
        addSubViewWithLayout(view: imageViewLogo)
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        addSubViewWithLayout(view: tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageViewLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageViewLogo.topAnchor.constraint(equalTo: topAnchor, constant: ViewTraits.verticalMargin),
            imageViewLogo.widthAnchor.constraint(equalToConstant: 200),
            imageViewLogo.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: imageViewLogo.bottomAnchor, constant: ViewTraits.verticalMargin),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ViewTraits.verticalMargin)
        ])
    }
}
