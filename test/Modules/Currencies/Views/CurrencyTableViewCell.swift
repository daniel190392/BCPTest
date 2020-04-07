//
//  CurrencyTableViewCell.swift
//  test
//
//  Created by Daniel Salhuana on 4/7/20.
//  Copyright © 2020 Daniel Salhuana. All rights reserved.
//

import UIKit

struct CurrencyViewModel {
    let imageFlagName: String
    let isoCode: String
    let country: String
    let changeDescription: String
}

class CurrencyTableViewCell: UITableViewCell {
    
    var imageViewCityFlag = UIImageView()
    var labelCountry = UILabel()
    var labelChange = UILabel()
    var viewSeparetor = UIView()
    
    static let identifier: String = "currencyTableViewCell"

    struct ViewTraits {
        
    }
    
    // MARK: View lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupComponents()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: Setup
    func setupComponents() {
        backgroundColor = .clear
        selectionStyle = .none
        
        imageViewCityFlag.contentMode = .scaleAspectFit
        imageViewCityFlag.image = UIImage(named: "BCP")
        contentView.addSubViewWithLayout(view: imageViewCityFlag)
        
        labelCountry.textColor = .black
        labelCountry.font = UIFont.regular14
        labelCountry.numberOfLines = 0
        contentView.addSubViewWithLayout(view: labelCountry)
        
        labelChange.textColor = .b_gray
        labelChange.font = UIFont.regular14
        contentView.addSubViewWithLayout(view: labelChange)
        
        viewSeparetor.backgroundColor = .b_gray
        contentView.addSubViewWithLayout(view: viewSeparetor)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageViewCityFlag.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageViewCityFlag.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageViewCityFlag.widthAnchor.constraint(equalToConstant: 80),
            imageViewCityFlag.heightAnchor.constraint(equalToConstant: 40),
            imageViewCityFlag.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageViewCityFlag.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            labelCountry.leadingAnchor.constraint(equalTo: imageViewCityFlag.trailingAnchor, constant: 8),
            labelCountry.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            labelCountry.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            labelChange.leadingAnchor.constraint(equalTo: imageViewCityFlag.trailingAnchor, constant: 8),
            labelChange.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            labelChange.topAnchor.constraint(equalTo: labelCountry.bottomAnchor, constant: 4),
            labelChange.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            viewSeparetor.leadingAnchor.constraint(equalTo: labelCountry.leadingAnchor),
            viewSeparetor.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewSeparetor.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            viewSeparetor.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func setupCell(isTheLast: Bool, viewModel: CurrencyViewModel) {
        viewSeparetor.isHidden = isTheLast
        imageViewCityFlag.image = UIImage(named: viewModel.imageFlagName)
        labelCountry.text = viewModel.country
        labelChange.text = viewModel.changeDescription
    }
}
