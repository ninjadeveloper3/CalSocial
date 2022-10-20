//
//  BaseViewController.swift
//  CalSocial
//
//  Created by DevBatch on 27/09/2019.
//  Copyright © 2019 DevBatch. All rights reserved.
//

import UIKit
import ImageSlideshow

class BaseViewController: UIViewController {

    //MARK: - Variables
    
    var isAnimated = false
    
    let localSource = [BundleImageSource(imageString: "Onboarding"), BundleImageSource(imageString: "Onboarding3"), BundleImageSource(imageString: "Onboarding5"), BundleImageSource(imageString: "Onboarding2")]
    
    let pageControl = UIPageControl()
    
    var isTour = false
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: MBButton!
    
    //MARK : - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpViewController()
        //self.present(CurvedTabBarController(), animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        }
    }
    
    //MARK: - SetUp ViewController Methods
    
    func setUpViewController() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Left-arrow"), style: .plain, target: self, action: #selector(backButtonTapped(sender:)) )
        imageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        let imageTintColor = UIImage.outlinedEllipse(size: CGSize(width: 7.0, height: 7.0), color: #colorLiteral(red: 0.8102070664, green: 0.8102070664, blue: 0.8102070664, alpha: 1))
        let imageFillColor = UIImage.outlinedFilled(size: CGSize(width: 7.0, height: 7.0), color: #colorLiteral(red: 0.8102070664, green: 0.8102070664, blue: 0.8102070664, alpha: 1), filledColor: #colorLiteral(red: 0.9214683175, green: 0.9216262698, blue: 0.9214583635, alpha: 1))
        pageControl.pageIndicatorTintColor = UIColor.init(patternImage: imageTintColor!)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.8102070664, green: 0.8102070664, blue: 0.8102070664, alpha: 1)
        imageSlideShow.pageIndicator = pageControl
        imageSlideShow.circular = false
        imageSlideShow.delegate = self
        imageSlideShow.setImageInputs(localSource)
        logoImageView.alpha = 0.0
        
        if isTour {
            loginButton.isHidden = true
            signUpButton.isHidden = true
        }
        else{
            loginButton.isHidden = false
            signUpButton.isHidden = false
        }
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
        
    }
    
    @objc func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}

extension BaseViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        
        if page >= 1 && !self.isAnimated {
            if !self.isAnimated{
                self.isAnimated = true
                self.logoImageView.fadeInUpBig()
                self.logoImageView.fadeInRightBig()
                UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
                }, completion: nil)
            }
        }
        else if page == 0 {
            self.isAnimated = false
            self.logoImageView.fadeOut()
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            }, completion: nil)
        }
        else{
            self.isAnimated = true
        }
        UIView.animate(withDuration: 0.3)
        {
            self.view.layoutIfNeeded()
        }
    }
}

extension UIImage {
    class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func outlinedFilled(size: CGSize, color: UIColor, filledColor: UIColor, lineWidth: CGFloat = 0.5) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        context.setFillColor(filledColor.cgColor)
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
