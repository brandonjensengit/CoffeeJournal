//
//  ImageCompression.swift
//  coffeeJournal
//
//  Created by Brandon Jensen on 10/26/25.
//

import UIKit

struct ImageCompression {
    // MARK: - Compression Settings

    /// Maximum width/height for compressed images
    static let maxDimension: CGFloat = 1200

    /// JPEG compression quality (0.0 to 1.0)
    static let compressionQuality: CGFloat = 0.7

    /// Target maximum file size in bytes (500KB)
    static let targetMaxSize: Int = 500_000

    // MARK: - Public Methods

    /// Compress image for efficient storage
    /// - Parameter image: Original UIImage
    /// - Returns: Compressed image data, or nil if compression fails
    static func compress(_ image: UIImage) -> Data? {
        // Step 1: Resize if needed
        let resizedImage = resizeImage(image, maxDimension: maxDimension)

        // Step 2: Apply JPEG compression
        guard var imageData = resizedImage.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }

        // Step 3: Further compress if still too large
        var currentQuality = compressionQuality
        while imageData.count > targetMaxSize && currentQuality > 0.3 {
            currentQuality -= 0.1
            if let compressedData = resizedImage.jpegData(compressionQuality: currentQuality) {
                imageData = compressedData
            } else {
                break
            }
        }

        return imageData
    }

    // MARK: - Private Methods

    /// Resize image to fit within max dimension while maintaining aspect ratio
    private static func resizeImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        let size = image.size

        // Check if resizing is needed
        guard size.width > maxDimension || size.height > maxDimension else {
            return image
        }

        // Calculate new size maintaining aspect ratio
        let aspectRatio = size.width / size.height
        var newSize: CGSize

        if size.width > size.height {
            newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }

        // Perform resize
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }

        return resizedImage
    }

    /// Get human-readable file size
    static func formatFileSize(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
}

// MARK: - UIImage Extension

extension UIImage {
    /// Compress the image using default settings
    func compressed() -> Data? {
        return ImageCompression.compress(self)
    }

    /// Get the file size of the compressed image
    var compressedSize: String? {
        guard let data = compressed() else { return nil }
        return ImageCompression.formatFileSize(data.count)
    }
}
