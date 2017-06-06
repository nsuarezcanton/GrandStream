//
//  ViewController.swift
//  GrandStream
//
//  Created by Nicolas Suarez-Canton Trueba on 6/5/17.
//  Copyright © 2017 Nicolas Suarez-Canton Trueba. All rights reserved.
//

import UIKit

class FeedController: UIViewController  {
    
    var tableImages: [String] = ["https://goo.gl/U753bm",
                                 "https://goo.gl/uzvhec",
                                 "https://goo.gl/z8mPT0",
                                 "https://goo.gl/CVEbwv",
                                 "https://goo.gl/UnXzw9",
                                 "https://goo.gl/3D9PYO",
                                 "https://goo.gl/3Y9YQu"]
    
    var selectedImage = 0
    
    var nextImageButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.blue
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(nextImageTouched), for: .touchUpInside)
        
        return button
    }()
    
    
    var activityIndicator: UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    lazy var imageOnDisplay: UIImageView = {

        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view?.backgroundColor = UIColor.white
        view.addSubview(imageOnDisplay)
        view.addSubview(activityIndicator)
        view.addSubview(nextImageButton)
        activityIndicator.stopAnimating()
        
        setImageOnDisplay()
        setActivityIndicator()
        setNextImageButton()
        
        chooseImage(imageNumber: selectedImage)
        
    }
    
    func setImageOnDisplay() {
        imageOnDisplay.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageOnDisplay.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageOnDisplay.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageOnDisplay.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
    }
    
    func setActivityIndicator() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setNextImageButton() {
        nextImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextImageButton.topAnchor.constraint(equalTo: imageOnDisplay.bottomAnchor, constant: 12).isActive = true
        nextImageButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        nextImageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    // Given an random number smaller than the size of the array tableImages,
    // function calls fetchImageFromURL to retrieve the image from the provided
    // URL using the background thread.
    func chooseImage(imageNumber: Int) {
        activityIndicator.startAnimating()
        let imageURL = URL(string: tableImages[imageNumber])
        selectedImage = imageNumber

        fetchImageFromURL(imageURL: imageURL!)
    }
    
    // Fetches an image from a given URL using the background thread.
    func fetchImageFromURL(imageURL: URL) {
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            let fetch = NSData(contentsOf: imageURL as URL)
            DispatchQueue.main.async {
                if let imageData = fetch {
                    self.activityIndicator.stopAnimating()
                    self.imageOnDisplay.image = UIImage(data: imageData as Data)
                }
            }
        }
    }
    
    // Handler that requests an additional image when the user taps on the next button.
    func nextImageTouched () {
        var number = Int(arc4random_uniform(UInt32(tableImages.count - 1)))
        print(number)
        while (number == selectedImage) {
            number = Int(arc4random_uniform(UInt32(tableImages.count - 1)))
            print(number)
        }
        chooseImage(imageNumber: number)
    }

}

