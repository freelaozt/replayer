import Cocoa
import VLCKit

class ViewController: NSViewController, VLCMediaPlayerDelegate {

    private var videoView: VLCVideoView!
    private var player: VLCMediaPlayer!

    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 1280, height: 720))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoView()
        setupPlayer()
    }

    private func setupVideoView() {
        videoView = VLCVideoView(frame: self.view.bounds)
        videoView.autoresizingMask = [.width, .height]
        videoView.wantsLayer = true
        videoView.layer?.backgroundColor = NSColor.black.cgColor
        view.addSubview(videoView)
    }

    private func setupPlayer(useHardwareDecode: Bool = true) {
        // 远程测试配置 开启了 App Sandbox（在 Xcode → Target → Signing & Capabilities → App Sandbox） Outgoing Connections (Client)
        guard let url = URL(string: "https://www.apple.com/105/media/us/iphone-xs/2018/674b340a-40f1-4156-bbea-00f386459d3c/films/design/iphone-xs-design-tpl-cc-us-2018_1280x720h.mp4") else { return }
        
        let media = VLCMedia(url: url)
        // 本地测试
//        let path = Bundle.main.path(forResource: "2", ofType: "mov")
//        let media = VLCMedia(path: path!)
        
        media.addOptions([
            "network-caching": 300,
            "file-caching": 300,
            "live-caching": 300,
            "clock-jitter": 0,
            "clock-synchro": 0
        ])
        
        player = VLCMediaPlayer(videoView: videoView)
        player.media = media
        player.delegate = self
        player.play()
        
        print("🎬 VLCMediaPlayer initialized")
    }

    // MARK: - VLC Delegate
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        guard let player = aNotification.object as? VLCMediaPlayer else { return }
        switch player.state {
        case .opening, .buffering:
            print("Buffering/opening...")
        case .playing:
            print("Playing")
        case .paused:
            print("Paused")
        case .stopped, .ended:
            print("Stopped/Ended")
        default:
            break
        }
    }

    func mediaPlayerEncounteredError(_ aNotification: Notification!) {
        print("VLC Player Error:", aNotification.userInfo ?? [:])
    }
}
