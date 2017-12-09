//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Ruben on 12/8/17.
//  Copyright © 2017 Ruben. All rights reserved.
//
import UIKit

///
/// View controller for choosing a theme for ConcentrationViewController
///
class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    // Called after interface-builder setup
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    // Make sure splitViewController shows master during startup
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let concentrationVC = secondaryViewController as? ConcentrationViewController {
            if concentrationVC.theme.name == "Default" { // small hack to keep logic similar to lecture
                return true // do not show the detail-view
            }
        }
        return false // show the detail
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "Choose Theme":
            // Destinaton VC must be a ConcentrationViewController
            if let concentrationVC = segue.destination as? ConcentrationViewController {
                // (Bad design): We are getting the theme from the button's title
                if let themeName = (sender as? UIButton)?.currentTitle {
                    // We should have a theme for the sender's themeName
                    if let theme = themes[themeName] {
                        concentrationVC.theme = theme
                    } // else, the concentrationVC will use a "default" theme
                }
            }
        default:
            break
        }
    }
    
    ///
    /// Change theme based on the option (button) selected
    ///
    @IBAction func changeTheme(_ sender: Any) {
        // Example of performing segue through code
        performSegue(withIdentifier: "Choose Theme", sender: sender)
        
        // Note: Lecture shows here how to update theme without creating a new MVC,
        // which I'm omitting.
    }
    
    ///
    /// Available themes the app supports.
    ///
    /// Add more themes as you please.
    ///
    private var themes: [String : ConcentrationViewController.Theme] = [
        "Christmas":
            ConcentrationViewController.Theme(name: "Christmas",
              boardColor: #colorLiteral(red: 0.9678710938, green: 0.9678710938, blue: 0.9678710938, alpha: 1),
              cardColor: #colorLiteral(red: 0.631328125, green: 0.1330817629, blue: 0.06264670187, alpha: 1),
              emojis: ["🎅", "🤶", "🧝", "🧦", "🦌", "🍪", "🥛", "🍷", "⛪", "🌟", "❄", "⛄",
                       "🎄", "🎁", "🔔", "🕯"]
            ),
        "Halloween":
            ConcentrationViewController.Theme(name: "Halloween",
              boardColor: #colorLiteral(red: 1, green: 0.8556062016, blue: 0.5505848702, alpha: 1),
              cardColor: #colorLiteral(red: 0.7928710937, green: 0.373980853, blue: 0, alpha: 1),
              emojis: ["💀", "👻", "👽", "🧙", "🧛", "🧟", "🦇", "🕷", "🕸", "🛸", "🎃", "🎭",
                       "🗡", "⚰"]
            ),
        "Faces":
            ConcentrationViewController.Theme(name: "Faces",
              boardColor: #colorLiteral(red: 0.9959731026, green: 1, blue: 0.8252459694, alpha: 1),
              cardColor: #colorLiteral(red: 0.8265820312, green: 0.7249050135, blue: 0.4632316118, alpha: 1),
              emojis: ["😀", "😁", "😂", "🤣", "😃", "😄", "😅", "😆", "😉", "😊", "😋", "😎",
                       "😍", "😘", "😗", "😙", "😚", "☺", "🙂", "🤗", "🤩", "🤔", "🤨", "😐",
                       "😑", "😶", "🙄", "😏", "😣", "😥", "😮", "🤐", "😯", "😪", "😫", "😴",
                       "😌", "😛", "😜", "😝", "🤤", "😒", "😓", "😔", "😕", "🙃", "🤑", "😲",
                       "☹", "🙁", "😖", "😞", "😟", "😤", "😢", "😭", "😦", "😧", "😨", "😩",
                       "🤯", "😬", "😰", "😱", "😳", "🤪", "😵", "😡", "😠", "🤬", "😷", "🤒",
                       "🤕", "🤢", "🤮", "🤧", "😇", "🤠", "🤡", "🤥", "🤫", "🤭", "🧐", "🤓"]
            ),
        "Animals":
            ConcentrationViewController.Theme(name: "Animals",
              boardColor: #colorLiteral(red: 0.8306297664, green: 1, blue: 0.7910112419, alpha: 1),
              cardColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),
              emojis: ["🙈", "🙉", "🙊", "💥", "💦", "💨", "💫", "🐵", "🐒", "🦍", "🐶", "🐕",
                       "🐩", "🐺", "🦊", "🐱", "🐈", "🦁", "🐯", "🐅", "🐆", "🐴", "🐎", "🦄",
                       "🦓", "🐮", "🐂", "🐃", "🐄", "🐷", "🐖", "🐗", "🐽", "🐏", "🐑", "🐐",
                       "🐪", "🐫", "🦒", "🐘", "🦏", "🐭", "🐁", "🐀", "🐹", "🐰", "🐇", "🐿",
                       "🦔", "🦇", "🐻", "🐨", "🐼", "🐾", "🦃", "🐔", "🐓", "🐣", "🐤", "🐥"]
            ),
        ]

}
