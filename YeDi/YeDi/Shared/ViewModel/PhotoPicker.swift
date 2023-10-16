//
//  PhotoPicker.swift
//  YeDi
//
//  Created by 박채영 on 2023/10/10.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController
    
    let onImagePicked: (URL) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let onImagePicked: (URL) -> Void
        
        init(onImagePicked: @escaping (URL) -> Void) {
            self.onImagePicked = onImagePicked
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            if let itemProvider = results.first?.itemProvider {
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                        if let image = object as? UIImage, let imageURL = self.saveImageToTemporaryDirectory(image: image) {
                            self.onImagePicked(imageURL)
                        }
                    }
                }
            }
        }
        
        func saveImageToTemporaryDirectory(image: UIImage) -> URL? {
            guard let data = image.jpegData(compressionQuality: 1.0) else {
                return nil
            }
            
            let tempDirectory = FileManager.default.temporaryDirectory
            let imageURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpeg")
            
            do {
                try data.write(to: imageURL)
                return imageURL
            } catch {
                return nil
            }
        }
    }
}
