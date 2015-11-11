import UIKit
import Foundation

class PlaybackViewController: UIViewController {

	lazy var drone = HomeViewController.drone
	var camera: DJICamera!
	
	@IBOutlet weak var previewView: UIView!
	@IBOutlet weak var debugLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addDebugInformation("Starting playback")
		camera = drone.camera
		camera.delegate = self
	}
	
	func addDebugInformation(message: String) {
		debugLabel.text = debugLabel.text! + "\n" + message
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		drone.connectToDrone()
		camera.startCameraSystemStateUpdates()
		
		VideoPreviewer.instance().start()
		VideoPreviewer.instance().setView(previewView)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		drone.disconnectToDrone()
		camera.stopCameraSystemStateUpdates()
		VideoPreviewer.instance().setView(nil)
	}
	
	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		
	}
	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
		VideoPreviewer.instance().setView(previewView)
	}
}

extension PlaybackViewController: DJICameraDelegate {
	
	func camera(camera: DJICamera!, didReceivedVideoData videoBuffer: UnsafeMutablePointer<UInt8>, length: Int32) {
		// keep as var
		var buffer = UnsafeMutablePointer<UInt8>.alloc(Int(length))
		memcpy(buffer, videoBuffer, Int(length))
		VideoPreviewer.instance().dataQueue.push(buffer, length: length)
	}
	
	func camera(camera: DJICamera!, didUpdateSystemState systemState: DJICameraSystemState!) {
//		addDebugInformation("Sys state: \(systemState)")
	}
	
}