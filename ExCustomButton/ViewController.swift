//
//  ViewController.swift
//  ExCustomButton
//
//  Created by 김종권 on 2023/01/03.
//

import UIKit

class ViewController: UIViewController {
    private let button: MyButton = {
        let button = MyButton()
        button.normalImage = UIImage(named: "img")
        button.highlightedImage = UIImage(named: "img")?.alpha(0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

class MyButton: UIButton {
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 12
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let myImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        return view
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.text = "label"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var text: String? {
        didSet { label.text = text }
    }
    var normalImage: UIImage? {
        didSet { updateStateUI() }
    }
    var highlightedImage: UIImage? {
        didSet { updateStateUI() }
    }
    
    override var isHighlighted: Bool {
        didSet { updateStateUI() }
    }

    init() {
        super.init(frame: .zero)
        setUp()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func setImage(_ image: UIImage?, for state: UIControl.State) {
//        super.setImage(image, for: state) <- 호출 x
        switch state {
        case .normal:
            normalImage = image
        case .highlighted:
            highlightedImage = image
        default:
            break
        }
    }

    private func setUp() {
        addSubview(stackView)
        [myImageView, label].forEach(stackView.addArrangedSubview(_:))

        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }

    private func updateStateUI() {
        switch state {
        case .normal:
            label.alpha = 1
            myImageView.image = normalImage
        case .highlighted:
            label.alpha = 0.5
            myImageView.image = highlightedImage
        default:
            break
        }
    }
}

// https://stackoverflow.com/questions/28517866/how-to-set-the-alpha-of-an-uiimage-in-swift-programmatically
extension UIImage {
    func alpha(_ value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
