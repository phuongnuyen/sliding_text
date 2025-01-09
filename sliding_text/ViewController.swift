//
//  ViewController.swift
//  sliding_text
//
//  Created by Phuong Nguyen on 8/1/25.
//

import UIKit
import SlidingText

class ViewController: UIViewController {
    
    private let slidingLabel = SlidingLabel()
    private let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slidingLabel.label.text = "There is no one who loves pain itself, who seeks after it and wants to have it, simply because it is pain..."
        
        slidingLabel.spacing = 50.0
        slidingLabel.backgroundColor = UIColor(red: 239/255, green: 243/255, blue: 234/255, alpha: 1.0)
        slidingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(slidingLabel)
        NSLayoutConstraint.activate([
            slidingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            slidingLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            slidingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        button.setTitle("Toggle", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonDidTouch), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: slidingLabel.bottomAnchor, constant: 50)
        ])
    }
    
    @objc func buttonDidTouch() {
        if slidingLabel.isSliding {
            slidingLabel.stopAnimation()
        } else {
            slidingLabel.startAnimation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        slidingLabel.startAnimation()
    }
}

