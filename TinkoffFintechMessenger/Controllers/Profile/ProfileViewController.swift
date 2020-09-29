//
//  ProfileViewController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 13.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

final class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileImageEditButton: UIButton!
    @IBOutlet private weak var profileImageLabel: UILabel!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userDescriptionLabel: UILabel!
    
    // MARK: - Private properties
    
    private let loggerSourceName = "ProfileViewController"
    private var currentState = UIViewController.State.loading
    private let buttonCornerRadius: CGFloat = 14
    private lazy var imagePickerController: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        vc.mediaTypes = [kUTTypeImage as String]
        return vc
    }()
    
    // MARK: - Initializer
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //Logger.info(loggerSourceName, "\(saveButton.frame)")
        //This throws an exception, because UI elements have not been loaded yet
    }
    
    // MARK: - UIViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newState = UIViewController.State.loaded
        Logger.stateInfo(loggerSourceName,
                         from: currentState.rawValue,
                         to: newState.rawValue,
                         methodName: #function)
        currentState = newState
        
        Logger.info(loggerSourceName, "\(saveButton.frame)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let newState = UIViewController.State.appearing
        Logger.stateInfo(loggerSourceName,
                         from: currentState.rawValue,
                         to: newState.rawValue,
                         methodName: #function)
        currentState = newState
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let newState = UIViewController.State.appeared
        Logger.stateInfo(loggerSourceName,
                         from: currentState.rawValue,
                         to: newState.rawValue,
                         methodName: #function)
        currentState = newState
        
        Logger.info(loggerSourceName, "\(saveButton.frame)")
        
        //When the viewDidLoad is called constraints of view controller's view subviews
        //are not properly set and its sizes are not finalised
        //After the viewDidLayoutSubviews is called all sizes have already been calculated
        //and are actual
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        Logger.info(loggerSourceName, #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Logger.info(loggerSourceName, #function)
        
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let newState = UIViewController.State.disappearing
        Logger.stateInfo(loggerSourceName,
                         from: currentState.rawValue,
                         to: newState.rawValue,
                         methodName: #function)
        currentState = newState
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let newState = UIViewController.State.disappeared
        Logger.stateInfo(loggerSourceName,
                         from: currentState.rawValue,
                         to: newState.rawValue,
                         methodName: #function)
        currentState = newState
    }
    
    // MARK: - IBActions
    
    @IBAction private func profileImageEditButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
        let actions = [
            UIAlertAction(title: "Open Gallery", style: .default) { [unowned self] _ in
                self.presentImagePicker(sourceType: .photoLibrary)
            },
            UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
                self.checkCameraPermission()
            },
            UIAlertAction(title: "Cancel", style: .cancel)]

        actions.forEach { alertController.addAction($0) }
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        saveButton.layer.cornerRadius = buttonCornerRadius
        profileImageLabel.isHidden = profileImageView.image != nil
    }
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return presentImagePicker(sourceType: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.presentImagePicker(sourceType: .camera)
                } else {
                    self.showErrorAlert()
                }
            }
        case .denied, .restricted:
            showErrorAlert()
        @unknown default:
            showErrorAlert()
        }
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            showErrorAlert()
            return
        }
        
        imagePickerController.sourceType = sourceType
        DispatchQueue.main.async {
            self.present(self.imagePickerController, animated: true)
        }
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "This action is not allowed.", preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

// MARK: -  UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            showErrorAlert()
            return
        }
        
        profileImageView.image = image
        profileImageLabel.isHidden = true
    }
}
