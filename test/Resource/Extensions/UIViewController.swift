//
//  UIViewController.swift
//  test
//
//  Created by Daniel Salhuana on 4/6/20.
//  Copyright © 2020 Daniel Salhuana. All rights reserved.
//

import UIKit

extension UIViewController {
    
    struct ViewTraits {
        static let buttonSize: CGFloat = 20.0
    }
    
    func loadNavigationBar(title: String, hideNavigation: Bool = false) {
        navigationItem.title = title
        let font = UIFont.bold20
        
        guard let navigationController = navigationController else {
            return
        }
        
        let navBartTitleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController.navigationBar.barStyle = .default
        navigationController.navigationBar.titleTextAttributes = navBartTitleTextAttributes as [NSAttributedString.Key: Any]
        navigationController.isNavigationBarHidden = hideNavigation
        navigationController.navigationBar.isTranslucent = false
        
        navigationController.navigationBar.barTintColor = UIColor.b_white
        navigationController.navigationBar.backgroundColor = UIColor.b_blue
        
        let image = UIImage()
        navigationController.navigationBar.shadowImage = image
        navigationController.navigationBar.setBackgroundImage(image, for: .default)
    }
    
    func addNavigationRightOption(target: Any?, selector: Selector, icon: UIImage?) {
        guard let rightOption = addNavigationOption(target: target, selector: selector, icon: icon) else {
            return
        }
        self.navigationItem.rightBarButtonItem = rightOption
    }
    
    func addNavigationLeftOption(target: Any?, selector: Selector, icon: UIImage?) {
        guard let leftOption = addNavigationOption(target: target, selector: selector, icon: icon) else {
            return
        }
        self.navigationItem.leftBarButtonItem = leftOption
    }
    
    private func addNavigationOption(target: Any?, selector: Selector, icon: UIImage?) -> UIBarButtonItem? {
        guard let target = target, let icon = icon else {
            return nil
        }
        let tapGesture = UITapGestureRecognizer(target: target, action: selector)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.addGestureRecognizer(tapGesture)
        addImageView(view: view, image: icon)
        
        return UIBarButtonItem(customView: view)
    }
    
    private func addImageView(view: UIView, image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        view.addSubViewWithLayout(view: imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: ViewTraits.buttonSize),
            view.heightAnchor.constraint(equalToConstant: ViewTraits.buttonSize)])
    }
}
