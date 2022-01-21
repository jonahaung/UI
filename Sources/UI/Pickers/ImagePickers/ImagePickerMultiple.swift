//
//  ImagePicker.swift
//  MyBike
//
//  Created by Aung Ko Min on 3/11/21.
//

import PhotosUI
import SwiftUI

public struct ImagePickerMultiple: UIViewControllerRepresentable {
    
    public typealias Completion = (_ selectedImage: [UIImage]) -> Void
    
    private var maxLimit: Int
    private var completion: Completion?
    
    @Environment(\.presentationMode) private var presentationMode
    
    public init(maxLimit: Int, completion: Completion?) {
        self.maxLimit = maxLimit
        self.completion = completion
    }
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = maxLimit
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    public func updateUIViewController(_: PHPickerViewController, context _: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: PHPickerViewControllerDelegate {
        
        private let parent: ImagePickerMultiple
        
        init(_ parent: ImagePickerMultiple) {
            self.parent = parent
        }
        
        public func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            let group = DispatchGroup()
            var images = [UIImage]()
            for result in results {
                group.enter()
                load(result) { image in
                    if let image = image {
                        let resizedImage = self.resize(image, to: 200)
                        images.append(resizedImage)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                self.parent.completion?(images)
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        private func load(_ image: PHPickerResult, completion: @escaping (UIImage?) -> Void ) {
            image.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("unable to unwrap image as UIImage")
                    completion(nil)
                    return
                }
                guard let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                completion(image)
            }
        }
        
        private func resize(_ image: UIImage, to width: CGFloat) -> UIImage {
            
            let oldWidth = image.size.width
            let scaleFactor = width / oldWidth
            
            let newHeight = image.size.height * scaleFactor
            let newWidth = oldWidth * scaleFactor
            
            let newSize = CGSize(width: newWidth, height: newHeight)

            return UIGraphicsImageRenderer(size: newSize).image { _ in
                image.draw(in: .init(origin: .zero, size: newSize))
            }
        }
    }
}
