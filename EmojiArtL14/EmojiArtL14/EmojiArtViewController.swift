//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Ruben on 1/12/18.
//  Copyright © 2018 Ruben. All rights reserved.
//

import UIKit

///
/// TODO: fill this header. So far, the controller allows the user to drag and drop an
/// image/url set into it. It will then show the image on screen.
///
class EmojiArtViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Model
    
    ///
    /// Represents an emojiArt document
    ///
    var emojiArt: EmojiArt? {
        get {
            guard let url = emojiArtBackgroundImage.url else {
                return nil
            }
            
            //
            // Emojis are obtained from the subviews in emojiArtView (only the ones that are UILabel).
            // For each label in emojiArtView, we then call mojiArt.EmojiInfo(label:) to create an EmojiInfo element
            //
            let emojis = emojiArtView.subviews.flatMap{ $0 as? UILabel }.flatMap{ EmojiArt.EmojiInfo(label: $0) }
            return EmojiArt(url: url, emojis: emojis)
        }
        set {
            // Reset storage
            emojiArtBackgroundImage = (nil, nil)
            
            // Remove all emoji labels
            emojiArtView.subviews.flatMap{ $0 as? UILabel }.forEach{ $0.removeFromSuperview() }
            
            // Make sure we have a valid url
            guard let url = newValue?.url else {
                return
            }
            
            // Fetch the image from the newly set url
            imageFetcher = ImageFetcher(fetch: url) { (url, image) in
                DispatchQueue.main.async {
                    self.emojiArtBackgroundImage = (url, image)
                    newValue?.emojis.forEach {
                        let center = CGPoint(x: $0.x, y: $0.y)
                        let emojiSize = CGFloat($0.size)
                        let attributedText = $0.text.attributedString(withTextStyle: .body, ofSize: emojiSize)
                        self.emojiArtView.addLabel(with: attributedText, centeredAt: center)
                    }
                }
            }
            
        }
    }
    
    // MARK: - Storyboard
    
    ///
    /// View that handles the drop interaction(s)
    ///
    @IBOutlet weak var dropZone: UIView! {
        didSet {
            // Set `self` as the delegate for drop interactions
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    ///
    /// UIView for creating awesome emoji-art
    ///
    var emojiArtView = EmojiArtView()
    
    ///
    /// Helper class for fetching images from the network in an async. way
    ///
    private var imageFetcher: ImageFetcher!
    
    ///
    /// Area that allows scrolling and zomming into the image
    ///
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(emojiArtView)
        }
    }
    
    //
    // Storage for computed var (tuple) emojiArtBackgroundImage.url
    //
    private var _emojiArtBackgroundImageURL: URL?
    
    ///
    /// The background image of the project.
    ///
    var emojiArtBackgroundImage: (url: URL?, image: UIImage?) {
        get {
            // Image is stored in emojiArtView
            return (_emojiArtBackgroundImageURL, emojiArtView.backgroundImage)
        }
        set {
            // Reset imageURl
            _emojiArtBackgroundImageURL = newValue.url
            
            // Reset zoomScale
            scrollView?.zoomScale = 1.0
            
            // Setup background image
            emojiArtView.backgroundImage = newValue.image
            
            // Setup appropriate size
            let size = newValue.image?.size ?? CGSize.zero
            
            // Frame starting at CGPoint.zero
            emojiArtView.frame = CGRect(origin: CGPoint.zero, size: size)
            
            // Setup scrolling size
            scrollView?.contentSize = size
            
            // Setup constraints of scrollView to properly fit the image's size
            scrollViewHeight?.constant = size.height
            scrollViewWidth?.constant = size.width
            
            // If appropriate, setup zoomScale
            if let dropZone = self.dropZone, size.width > 0, size.height > 0 {
                scrollView?.zoomScale = max(
                    dropZone.bounds.size.width / size.width,
                    dropZone.bounds.size.height / size.height
                )
            }
        }
    }

    ///
    /// UI Constraints for setting up the scrollView's height
    ///
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    ///
    /// UI Constraints for setting up the scrollView's height
    ///
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!

    ///
    /// List of emojis shown on top that the user may drag into the document.
    ///
    var emojis: [String] = "😀😁😂🤣😃😄😅😆😉😊😋😎😍😘😗😙😚☺️🙂🤗🤩🤔🤨😐😑😶🙄😏😣😥😮🤐😯😪😫😴😌😛😜😝🤤😒😓😔😕🙃🤑😲☹️🙁😖😞😟😤😢😭😦😧😨😩🤯😬😰😱😳🤪😵😡😠🤬😷🤒🤕🤢🤮🤧😇🤠🤡🤥🤫🤭🧐🤓😈👿👹👺💀👻👽🤖💩😺😸😹😻😼😽🙀😿😾👶👦👧👨👩👴👵👨‍⚕️👩‍⚕️👨‍🎓👩‍🎓👨‍⚖️👩‍⚖️👨‍🌾👩‍🌾👨‍🍳👩‍🍳👨‍🔧👩‍🔧👨‍🏭👩‍🏭👨‍💼👩‍💼👨‍🔬👩‍🔬👨‍💻👩‍💻👨‍🎤👩‍🎤👨‍🎨👩‍🎨👨‍✈️👩‍✈️👨‍🚀👩‍🚀👨‍🚒👩‍🚒👮👮‍♂️👮‍♀️🕵🕵️‍♂️🕵️‍♀️💂💂‍♂️💂‍♀️👷👷‍♂️👷‍♀️🤴👸👳👳‍♂️👳‍♀️👲🧕🧔👱👱‍♂️👱‍♀️🤵👰🤰🤱👼🎅🤶🧙‍♀️🧙‍♂️🧚‍♀️🧚‍♂️🧛‍♀️🧛‍♂️🧜‍♀️🧜‍♂️🧝‍♀️🧝‍♂️🧞‍♀️🧞‍♂️🧟‍♀️🧟‍♂️🙍🙍‍♂️🙍‍♀️🙎🙎‍♂️🙎‍♀️🙅🙅‍♂️🙅‍♀️🙆🙆‍♂️🙆‍♀️💁💁‍♂️💁‍♀️🙋🙋‍♂️🙋‍♀️🙇🙇‍♂️🙇‍♀️🤦🤦‍♂️🤦‍♀️🤷🤷‍♂️🤷‍♀️💆💆‍♂️💆‍♀️💇💇‍♂️💇‍♀️🚶🚶‍♂️🚶‍♀️🏃🏃‍♂️🏃‍♀️💃🕺👯👯‍♂️👯‍♀️🧖‍♀️🧖‍♂️🕴🗣👤👥👫👬👭💏👨‍❤️‍💋‍👨👩‍❤️‍💋‍👩💑👨‍❤️‍👨👩‍❤️‍👩👪👨‍👩‍👦👨‍👩‍👧👨‍👩‍👧‍👦👨‍👩‍👦‍👦👨‍👩‍👧‍👧👨‍👨‍👦👨‍👨‍👧👨‍👨‍👧‍👦👨‍👨‍👦‍👦👨‍👨‍👧‍👧👩‍👩‍👦👩‍👩‍👧👩‍👩‍👧‍👦👩‍👩‍👦‍👦👩‍👩‍👧‍👧👨‍👦👨‍👦‍👦👨‍👧👨‍👧‍👦👨‍👧‍👧👩‍👦👩‍👦‍👦👩‍👧👩‍👧‍👦👩‍👧‍👧🤳💪👈👉☝️👆🖕👇✌️🤞🖖🤘🖐✋👌👍👎✊👊🤛🤜🤚👋🤟✍️👏👐🙌🤲🙏🤝💅👂👃👣👀👁🧠👅👄💋👓🕶👔👕👖🧣🧤🧥🧦👗👘👙👚👛👜👝🎒👞👟👠👡👢👑👒🎩🎓🧢⛑💄💍🌂💼👐🏻🙌🏻👏🏻🙏🏻👍🏻👎🏻👊🏻✊🏻🤛🏻🤜🏻🤞🏻✌🏻🤘🏻👌🏻👈🏻👉🏻👆🏻👇🏻☝🏻✋🏻🤚🏻🖐🏻🖖🏻👋🏻🤙🏻💪🏻🖕🏻✍🏻🤳🏻💅🏻👂🏻👃🏻👶🏻👦🏻👧🏻👨🏻👩🏻👱🏻‍♀️👱🏻👴🏻👵🏻👲🏻👳🏻‍♀️👳🏻👮🏻‍♀️👮🏻👷🏻‍♀️👷🏻💂🏻‍♀️💂🏻🕵🏻‍♀️🕵🏻👩🏻‍⚕️👨🏻‍⚕️👩🏻‍🌾👨🏻‍🌾👩🏻‍🍳👨🏻‍🍳👩🏻‍🎓👨🏻‍🎓👩🏻‍🎤👨🏻‍🎤👩🏻‍🏫👨🏻‍🏫👩🏻‍🏭👨🏻‍🏭👩🏻‍💻👨🏻‍💻👩🏻‍💼👨🏻‍💼👩🏻‍🔧👨🏻‍🔧👩🏻‍🔬👨🏻‍🔬👩🏻‍🎨👨🏻‍🎨👩🏻‍🚒👨🏻‍🚒👩🏻‍✈️👨🏻‍✈️👩🏻‍🚀👨🏻‍🚀👩🏻‍⚖️👨🏻‍⚖️🤶🏻🎅🏻👸🏻🤴🏻👰🏻🤵🏻👼🏻🤰🏻🙇🏻‍♀️🙇🏻💁🏻💁🏻‍♂️🙅🏻🙅🏻‍♂️🙆🏻🙆🏻‍♂️🙋🏻🙋🏻‍♂️🤦🏻‍♀️🤦🏻‍♂️🤷🏻‍♀️🤷🏻‍♂️🙎🏻🙎🏻‍♂️🙍🏻🙍🏻‍♂️💇🏻💇🏻‍♂️💆🏻💆🏻‍♂️🕴🏻💃🏻🕺🏻🚶🏻‍♀️🚶🏻🏃🏻‍♀️🏃🏻🏋🏻‍♀️🏋🏻🤸🏻‍♀️🤸🏻‍♂️⛹🏻‍♀️⛹🏻🤾🏻‍♀️🤾🏻‍♂️🏌🏻‍♀️🏌🏻🏄🏻‍♀️🏄🏻🏊🏻‍♀️🏊🏻🤽🏻‍♀️🤽🏻‍♂️🚣🏻‍♀️🚣🏻🏇🏻🚴🏻‍♀️🚴🏻🚵🏻‍♀️🚵🏻🤹🏻‍♀️🤹🏻‍♂️🛀🏻👐🏼🙌🏼👏🏼🙏🏼👍🏼👎🏼👊🏼✊🏼🤛🏼🤜🏼🤞🏼✌🏼🤘🏼👌🏼👈🏼👉🏼👆🏼👇🏼☝🏼✋🏼🤚🏼🖐🏼🖖🏼👋🏼🤙🏼💪🏼🖕🏼✍🏼🤳🏼💅🏼👂🏼👃🏼👶🏼👦🏼👧🏼👨🏼👩🏼👱🏼‍♀️👱🏼👴🏼👵🏼👲🏼👳🏼‍♀️👳🏼👮🏼‍♀️👮🏼👷🏼‍♀️👷🏼💂🏼‍♀️💂🏼🕵🏼‍♀️🕵🏼👩🏼‍⚕️👨🏼‍⚕️👩🏼‍🌾👨🏼‍🌾👩🏼‍🍳👨🏼‍🍳👩🏼‍🎓👨🏼‍🎓👩🏼‍🎤👨🏼‍🎤👩🏼‍🏫👨🏼‍🏫👩🏼‍🏭👨🏼‍🏭👩🏼‍💻👨🏼‍💻👩🏼‍💼👨🏼‍💼👩🏼‍🔧👨🏼‍🔧👩🏼‍🔬👨🏼‍🔬👩🏼‍🎨👨🏼‍🎨👩🏼‍🚒👨🏼‍🚒👩🏼‍✈️👨🏼‍✈️👩🏼‍🚀👨🏼‍🚀👩🏼‍⚖️👨🏼‍⚖️🤶🏼🎅🏼👸🏼🤴🏼👰🏼🤵🏼👼🏼🤰🏼🙇🏼‍♀️🙇🏼💁🏼💁🏼‍♂️🙅🏼🙅🏼‍♂️🙆🏼🙆🏼‍♂️🙋🏼🙋🏼‍♂️🤦🏼‍♀️🤦🏼‍♂️🤷🏼‍♀️🤷🏼‍♂️🙎🏼🙎🏼‍♂️🙍🏼🙍🏼‍♂️💇🏼💇🏼‍♂️💆🏼💆🏼‍♂️🕴🏼💃🏼🕺🏼🚶🏼‍♀️🚶🏼🏃🏼‍♀️🏃🏼🏋🏼‍♀️🏋🏼🤸🏼‍♀️🤸🏼‍♂️⛹🏼‍♀️⛹🏼🤾🏼‍♀️🤾🏼‍♂️🏌🏼‍♀️🏌🏼🏄🏼‍♀️🏄🏼🏊🏼‍♀️🏊🏼🤽🏼‍♀️🤽🏼‍♂️🚣🏼‍♀️🚣🏼🏇🏼🚴🏼‍♀️🚴🏼🚵🏼‍♀️🚵🏻🤹🏼‍♀️🤹🏼‍♂️🛀🏼".map { String($0) }
    
    ///
    /// Collection view containing emojis that the user can drag and drop into the dropZone
    ///
    @IBOutlet weak var emojiCollectionView: UICollectionView! {
        didSet {
            emojiCollectionView.delegate = self
            emojiCollectionView.dataSource = self
            emojiCollectionView.dragDelegate = self
            emojiCollectionView.dropDelegate = self
            emojiCollectionView.dragInteractionEnabled = true // this makes sure it is enabled in iPhone as well
        }
    }
    
    ///
    /// Font to use when dropping emoji's into the dropZone
    ///
    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for:
            UIFont.preferredFont(forTextStyle: .body).withSize(40.0)
        )
    }
    
    ///
    /// Keeps track of whether or not the user is adding an Emoji
    ///
    private var addingEmoji = false
    
    ///
    /// Add emoji button was clicked
    ///
    @IBAction func addEmoji() {
        // Update internal state to "adding emoji"
        addingEmoji = true
        
        // Reloading section 0 with the prev. addingEmoji=true instruction will show
        // a "input textfield" where the user may add new emojis.
        emojiCollectionView.reloadSections(IndexSet(integer: 0))
    }
    
    ///
    /// The EmojiArtDocument we're using do open/save the docuemnt
    ///
    var document: EmojiArtDocument?
    
    ///
    /// Called when document changes. It will, for intance, save the document
    ///
//    @IBAction func save(_ sender: UIBarButtonItem? = nil) {
    func documentChanged(_ sender: UIBarButtonItem? = nil) {
        // Update document with model
        document?.emojiArt = emojiArt
        
        if document?.emojiArt != nil {
            // Tell document it changed so that it does autosave
            document?.updateChangeCount(.done)
        }
    }
    
    ///
    /// Close the current document. Saves it before doing so.
    ///
    @IBAction func close(_ sender: UIBarButtonItem) {
        
        // Stop observing for EmojiArtViewDidChange notifications
        if let observer = emojiArtViewObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        
        // Let's save before we close
        documentChanged()
        
        if document?.emojiArt != nil {
            // Create a "thumbnail" for this document
            document?.thumbnail = emojiArtView.snapshot
        }
        
        // Dismiss the ViewController
        dismiss(animated: true) {
            // Close it after it has been dismissed
            self.document?.close { success in
                // Lecture #15: Stop observing document changes
                if let documentObserver = self.documentObserver {
                    NotificationCenter.default.removeObserver(documentObserver)
                }
            }
        }
    }
    
    // Used as a cookie to tell notificacion center when to stop observing document changes
    private var documentObserver: NSObjectProtocol?

    private var emojiArtViewObserver: NSObjectProtocol?
    
    //
    // View will appear
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Lecture #15: Observe document state
        NotificationCenter.default.addObserver(
            forName: Notification.Name.UIDocumentStateChanged,
            object: document,
            queue: OperationQueue.main) { (notification) in
                print("--- Document state changed to: \(self.document?.documentState.description)") // temporary debug
        }
        
        // Open document
        document?.open { success in
            if success {
                // Setup controller's title to reflect the document we're working on
                self.title = self.document?.localizedName
                // Setup model
                self.emojiArt = self.document?.emojiArt
                
                self.emojiArtViewObserver = NotificationCenter.default.addObserver(
                    forName: .EmojiArtViewDidChange,
                    object: self.emojiArtView,
                    queue: OperationQueue.main,
                    using: { (notification) in
                        self.documentChanged()
                })
            }
            else {
                print("Failed to open document.")
            }
        }
    }
    
    ///
    /// Whether or not we want to show warnings when dropping images fail
    ///
    private var supressBadURLWarnings = false
}

// Conform to `UIDropInteractionDelegate`
extension EmojiArtViewController: UIDropInteractionDelegate {
    ///
    /// Return whether the delegate is interested in the given session
    ///
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        // Drag must be URL and UIImage. (Using NSURL because this is an objective-c api. Although we
        // have automatic-bridging between objective-c's NSURL and swift's URL, we must use NSURL.self
        // because we're passing the specific class to `canLoadObjects`)
        return session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: NSURL.self)
    }
    
    ///
    /// Tells the delegate the drop session has changed.
    ///
    /// You must implement this method if the drop interaction’s view can accept drop activities. If
    /// you don’t provide this method, the view cannot accept any drop activities.
    ///
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        // Copy whatever is being dropped into the view
        return UIDropProposal(operation: .copy)
    }
    
    ///
    /// Tells the delegate it can request the item provider data from the session’s drag items.
    ///
    /// You can request a drag item's itemProvider data within the scope of this method only and
    /// not at any other time.
    ///
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        // Image fetcher allows to fetch an image in the background based on given URL
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.emojiArtBackgroundImage = (url, image)
            }
        }
        
        // Process the array of URL's
        session.loadObjects(ofClass: NSURL.self) { nsurls in
            // We only care about the first one. If there were others, ignore them.
            if let url = nsurls.first as? URL {
                
                // Asynchronously fetch the image based on the given url.
                DispatchQueue.global(qos: .userInitiated).async {
                    if let data = try? Data(contentsOf: url.imageURL), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.emojiArtBackgroundImage = (url, image)
                            self.document?.updateChangeCount(.done)
                        }
                    }
                    else {
                        // Drop failed, we couldn't fetch image from url
                        self.presentBadURLWarning(for: url)
                    }
                }
            }
        }
        
        // Process the array of images
        session.loadObjects(ofClass: UIImage.self) { images in
            // We only care about the first one. If there were others, ignore them.
            if let image = images.first as? UIImage {
                // Set the image as the fetcher's backup
                self.imageFetcher.backup = image
            }
        }
    }
    
    
    ///
    /// Presents a warning indicating that the given url couldn't be fetched.
    ///
    private func presentBadURLWarning(for url: URL) {
        
        // Don't show any warning if supressBadURLWarnings == true
        if supressBadURLWarnings {
            return
        }
        
        // Alert to show the warning
        let alert = UIAlertController(
            title: "Image transfer failed",
            message: "Transfering the image dropped failed.\nKeep showing this warnings?",
            preferredStyle: .alert
        )
        
        // Action #1: Keep warning
        alert.addAction(UIAlertAction(title: "Keep Warning", style: .default))
        
        // Action #2: Stop warning
        alert.addAction(UIAlertAction(title: "Stop Warning", style: .destructive) { alert in
            self.supressBadURLWarnings = true
        })
        
        // Present the warning
        present(alert, animated: true)
    }
}

// Conform to `UIScrollViewDelegate`
extension EmojiArtViewController: UIScrollViewDelegate {
    //
    // Asks the delegate for the view to scale when zooming is about to occur in the scroll view.
    //
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // The view we want to scale
        return emojiArtView
    }
    
    //
    // Tells the delegate that the scroll view’s zoom factor changed.
    //
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }
}

// Conform to `UICollectionViewDropDelegate`
extension EmojiArtViewController: UICollectionViewDropDelegate {
    
    ///
    /// What to do when dropping items
    ///
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        // We don't want dropping into section 0 (that section is for adding new emojis only)
        if let indexPath = destinationIndexPath, indexPath.section == 0 {
            return UICollectionViewDropProposal(operation: .cancel)
        }
        
        // Determine if the drop is coming from within the collectionView
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        
        // If dropping items from within the collectionView, move them, otherwise copy them
        return UICollectionViewDropProposal(operation: (isSelf ? .move : .copy), intent: .insertAtDestinationIndexPath)
    }
    
    ///
    /// Tell collectionView whether or not the dropSession is valid and we can receive it
    ///
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        // Session must provide an attributed string
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    ///
    /// Perform the drop of an item into the collection view
    ///
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        // The index path where the drop would be inserted
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        // Process each item
        for item in coordinator.items {
            
            // Is this a local drag?
            if let sourceIndexPath = item.sourceIndexPath {
                
                // Item should contain an attributed string
                if let attributedString = item.dragItem.localObject as? NSAttributedString {
                    
                    // performBatchUpdates: Animates multiple insert, delete, reload, and move operations as a group.
                    collectionView.performBatchUpdates({
                        // Update model
                        emojis.remove(at: sourceIndexPath.item)
                        emojis.insert(attributedString.string, at: destinationIndexPath.item)
                        
                        // Update view
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            }
            // This is NOT a local drag (drop comes from somewhere else)
            else {
                // Temporarily drop a "loading" cell while the actual one (provided by the itemProvider) loads
                let placeholderContext = coordinator.drop(
                    item.dragItem,
                    to: UICollectionViewDropPlaceholder(
                        insertionIndexPath: destinationIndexPath,
                        reuseIdentifier: "DropPlaceholderCell" // "DropPlaceholderCell" contains a loading spinning wheel
                    )
                )
                
                // Load the attributed-string into the collectionView
                item.dragItem.itemProvider.loadObject(ofClass: NSAttributedString.self) { (provider, error) in
                    
                    // Update UI in the main queue
                    DispatchQueue.main.async {
                        // Check if provider is a string
                        if let attributedString = provider as? NSAttributedString {
                            // All good! do the actual insertion (exchanges the placeholder cell for one with the final content.)
                            placeholderContext.commitInsertion { insertionIndexPath in
                                self.emojis.insert(attributedString.string, at: insertionIndexPath.item)
                            }
                        } else {
                            // We couldn't do insertion, delete the placeholder
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
            
        }
    }
}

// Conform to `UICollectionViewDragDelegate`
extension EmojiArtViewController: UICollectionViewDragDelegate {
    
    ///
    /// Which items are we initially providing with the drag
    ///
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItem(at: indexPath)
    }
    
    ///
    /// Items are being added to the drag
    ///
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItem(at: indexPath)
    }
    
    ///
    /// Return array of `UIDragItem` representing the cell at `indexPath`
    ///
    private func dragItem(at indexPath: IndexPath) -> [UIDragItem] {
        
        // If user is adding an emoji, disable dragging
        if addingEmoji {
            return []
        }
        
        // Get the cell containing the emoji
        guard let emojiCell = emojiCollectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell else {
            return []
        }
        
        // Get the attributed-string representing the emoji
        guard let attributedString = emojiCell.label.attributedText else {
            return []
        }
        
        // Create drag-item with the attributed string
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: attributedString))
        
        // The localObject property gives you the option to associate a custom object, such as a model object,
        // with the drag item. The local object is available only to the app that initiates the drag activity.
        dragItem.localObject = attributedString
        
        // Return it
        return [dragItem]
    }
}

// Conform to `UICollectionViewDataSource`
extension EmojiArtViewController: UICollectionViewDataSource {
    
    // Number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Section #0: Contains only one cell: either "+" (add) emoji cell, or the "input" textField to add emojis
        // Section #1: The list of emojis
        return 2
    }
    
    // Number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        // Section #0: Contains only one cell: either "+" (add) emoji cell, or the "input" textField to add emojis
        case 0: return 1
        // Section #1: The list of emojis
        case 1: return emojis.count
        // Should not occur
        default: return 0
        }
    }
    
    // Get cell for item at given indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // List of emojis available
        if indexPath.section == 1 {
            // Dequeue a reusable emoji-cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
            
            // Make sure it is the expected EmojiCollectionViewCell type
            guard let emojiCell = cell as? EmojiCollectionViewCell else {
                return cell
            }
            
            // Create attributed-string with the proper emoji and the predefined font
            let text = NSAttributedString(string: emojis[indexPath.item], attributes: [.font: font])
            
            // Setup cell
            emojiCell.label.attributedText = text
            
            // Return it
            return emojiCell
        }
        // If we're not in section 1, and we are adding an emoji, we want to show the "EmojiInputCell" cell
        else if addingEmoji {
            
            // Add emoji cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiInputCell", for: indexPath)
            
            // Must be of type TextFieldCollectionViewCell
            if let inputCell = cell as? TextFieldCollectionViewCell {
                
                // Resignation handler gets called when editing of the textField ends
                inputCell.resignationHandler = { [weak self, unowned inputCell] in
                    
                    // Get the text we want to add
                    if let text = inputCell.textField.text {
                        // Add list of emojis (characters) to the beginning of `emojis`
                        self?.emojis = ((text.map{ String($0)}) + self!.emojis).uniquified
                    }
                    // We're no longer adding emojis
                    self?.addingEmoji = false
                    // We want to reload the view/table since the model changed
                    self?.emojiCollectionView.reloadData()
                }
            }
            return cell
        }
        // If we are not adding an emoji, show the "+" (add) emoji cell
        else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "AddEmojiButtonCell", for: indexPath)
        }
    }
    
    // Size for item at indexPath
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // If we're adding an emoji, we want to show the input cell wider than usual
        if addingEmoji && indexPath.section == 0 {
            return CGSize(width: 300, height: 80)
        }
        // Regular cells have a fixed size of NxN
        else {
            return CGSize(width: 80, height: 80)
        }
    }
    
    // Will display cell at indexPath
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // If we're about to display the TextFieldCollectionViewCell cell, we want to show the keyboard.
        if let inputCell = cell as? TextFieldCollectionViewCell {
            // Show keyboard
            inputCell.textField.becomeFirstResponder()
        }
    }
}


//
// Useful controller-related utilities for EmojiArt.EmojiInfo
//
extension EmojiArt.EmojiInfo {
    
    ///
    /// Creates a new EmojiArt.EmojiInfo from the given UILabel
    ///
    init?(label: UILabel) {
        
        // We need attributedText (to know the actual emoji text and size)
        guard let attributedText = label.attributedText else {
            return nil
        }
        
        // We need font (to know the emoji size)
        guard let font = attributedText.font else {
            return nil
        }
        
        // Create the object
        self.x = Int(label.center.x)
        self.y = Int(label.center.y)
        self.size = Int(font.pointSize)
        self.text = attributedText.string
    }
}

// Temporary extension to debug tracking of document state
extension UIDocumentState {
    var description: String {
        if self == UIDocumentState.closed {
            return "closed"
        }
        else if self == UIDocumentState.editingDisabled {
            return "editingDisabled"
        }
        else if self == UIDocumentState.inConflict {
            return "inConflict"
        }
        else if self == UIDocumentState.normal {
            return "normal"
        }
        else if self == UIDocumentState.progressAvailable {
            return "progressAvailable"
        }
        else if self == UIDocumentState.savingError {
            return "savingError"
        }
        else {
            return "(other)"
        }
    }
}
