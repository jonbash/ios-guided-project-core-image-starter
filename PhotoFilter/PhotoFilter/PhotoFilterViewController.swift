import UIKit
import CoreImage
import Photos

class PhotoFilterViewController: UIViewController {

    var originalImage: UIImage?

    private var filter = CIFilter(name: "CIColorControls")!
    private var context = CIContext(options: nil)

	@IBOutlet var brightnessSlider: UISlider!
	@IBOutlet var contrastSlider: UISlider!
	@IBOutlet var saturationSlider: UISlider!
	@IBOutlet var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

        originalImage = imageView.image
	}

    private func filterImage(_ image: UIImage?) -> UIImage? {
        guard
            let thisImage = image,
            let cgImage = thisImage.cgImage else { return image } // CGImage = pixel/bitmap data
        let ciImage = CIImage(cgImage: cgImage)

        // set up filter
        filter.setValuesForKeys([
            kCIInputImageKey: ciImage,
            kCIInputBrightnessKey: brightnessSlider.value,
            kCIInputContrastKey: contrastSlider.value,
            kCIInputSaturationKey: saturationSlider.value
        ])

        guard
            let outputCIImage = filter.outputImage,     // get output
            let outputCGImage = context.createCGImage(  // render image
                outputCIImage,
                from: CGRect(origin: CGPoint.zero,
                             size: thisImage.size))
            else { return thisImage }

        return UIImage(cgImage: outputCGImage)          // convert to uiimage
    }

	// MARK: Actions
	
	@IBAction func choosePhotoButtonPressed(_ sender: Any) {
		// TODO: show the photo picker so we can choose on-device photos
		// UIImagePickerController + Delegate
	}
	
	@IBAction func savePhotoButtonPressed(_ sender: UIButton) {

		// TODO: Save to photo library
	}
	

	// MARK: Slider events
	
	@IBAction func brightnessChanged(_ sender: UISlider) {
        updateImage()
	}
	
	@IBAction func contrastChanged(_ sender: Any) {
        updateImage()
	}
	
	@IBAction func saturationChanged(_ sender: Any) {
        updateImage()
	}

    private func updateImage() {
        imageView.image = filterImage(originalImage)
    }
}
