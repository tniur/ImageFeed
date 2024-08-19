//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Pavel on 05.02.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    private var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            if let newImage = image {
                rescaleAndCenterImageInScrollView(image: newImage)
            }
        }
    }
    var url : URL?
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        setupImage()
    }
    
    // MARK: - Functions
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let shareImage = imageView.image else { return }
        
        let share = UIActivityViewController(
            activityItems: [shareImage],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func setupImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Что-то пошло не так. Попробовать ещё раз?",
            preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "error"
        
        let dismissAction = UIAlertAction(title: "Не надо", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        let tryAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.setupImage()
        }
        
        alert.addAction(dismissAction)
        alert.addAction(tryAction)
        self.present(alert, animated: true)
    }
}

// MARK: - ScrollView Configuration

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
