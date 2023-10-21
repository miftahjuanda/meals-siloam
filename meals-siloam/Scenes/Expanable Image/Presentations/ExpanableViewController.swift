//
//  ExpanableViewController.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import UIKit

internal final class ExpanableViewController: UIViewController {
    private let spacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var mainScroll: ScrollView = {
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(onDoubleTap))
        tapRecognizer.numberOfTapsRequired = 2
        
        let scroll = ScrollView(contentStack: .init(){})
        scroll.delegate = self
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 4.0
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.center = view.center
        scroll.addGestureRecognizer(tapRecognizer)
        return scroll
    }()
    
    private let expanableImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.image = .dataEmptyIcon
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    init(image: UIImage) {
        self.expanableImage.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIExpanable()
    }
    
    private func setUIExpanable() {
        view.backgroundColor = .white
        
        view.addSubview(spacer)
        view.addSubview(mainScroll)
        mainScroll.addSubview(expanableImage)
        NSLayoutConstraint.activate([
            spacer.heightAnchor.constraint(equalToConstant: 5),
            spacer.widthAnchor.constraint(equalToConstant: 46),
            spacer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 10),
            spacer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            mainScroll.topAnchor.constraint(equalTo: spacer.bottomAnchor,
                                            constant: 50),
            mainScroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScroll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            expanableImage.topAnchor.constraint(equalTo: mainScroll.topAnchor),
            expanableImage.bottomAnchor.constraint(equalTo: mainScroll.bottomAnchor),
            expanableImage.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor),
            expanableImage.trailingAnchor.constraint(equalTo: mainScroll.trailingAnchor),
            expanableImage.widthAnchor.constraint(equalTo: mainScroll.widthAnchor)
        ])
    }
    
    @objc func onDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        let scale = min(mainScroll.zoomScale * 2, mainScroll.maximumZoomScale)
        
        if scale != mainScroll.zoomScale {
            let point = gestureRecognizer.location(in: expanableImage)
            
            let scrollSize = mainScroll.frame.size
            let size = CGSize(width: scrollSize.width / scale,
                              height: scrollSize.height / scale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            mainScroll.zoom(to:CGRect(origin: origin, size: size), animated: true)
        } else {
            mainScroll.setZoomScale(1.0, animated: true)
        }
    }
    
}

extension ExpanableViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return expanableImage
    }
}
