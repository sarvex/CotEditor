//
//  FindPanelTextView.swift
//
//  CotEditor
//  https://coteditor.com
//
//  Created by 1024jp on 2015-03-04.
//
//  ---------------------------------------------------------------------------
//
//  © 2015-2023 1024jp
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import AppKit

/// text view that behaves like a NSTextField
class FindPanelTextView: NSTextView {
    
    var action: Selector?
    var target: AnyObject?
    
    
    // MARK: Private Properties
    
    @objc private dynamic var isEmpty: Bool = true
    
    
    
    // MARK: -
    // MARK: Lifecycle
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        // set system font (standard NSTextField behavior)
        self.font = .systemFont(ofSize: 0)
        
        // set inset a bit like NSTextField (horizontal inset is added in FindPanelTextClipView)
        self.textContainerInset = NSSize(width: 0.0, height: 2.0)
        
        // avoid wrapping
        self.textContainer?.widthTracksTextView = false
        self.textContainer?.size = .infinite
        self.isHorizontallyResizable = true
        
        // disable automatic text substitutions
        self.isAutomaticQuoteSubstitutionEnabled = false
        self.isAutomaticDashSubstitutionEnabled = false
        self.isAutomaticTextReplacementEnabled = false
        self.isAutomaticSpellingCorrectionEnabled = false
        self.smartInsertDeleteEnabled = false
        
        // set subclassed layout manager for invisible characters
        let layoutManager = FindPanelLayoutManager()
        self.textContainer?.replaceLayoutManager(layoutManager)
    }
    
    
    
    // MARK: TextView Methods
    
    /// view is on focus
    override func becomeFirstResponder() -> Bool {
        
        // select whole string on focus (standard NSTextField behavior)
        self.selectedRange = self.string.nsRange
        
        return super.becomeFirstResponder()
    }
    
    
    /// view dismiss focus
    override func resignFirstResponder() -> Bool {
        
        // clear current selection (standard NSTextField behavior)
        self.selectedRange = NSRange(0..<0)
        
        return super.resignFirstResponder()
    }
    
    
    /// content string did update
    override func didChangeText() {
        
        super.didChangeText()
        
        self.isEmpty = self.string.isEmpty
    }
    
    
    /// string did update via binding
    override var string: String {
        
        didSet {
            self.isEmpty = string.isEmpty
        }
    }
    
    
    /// perform the action with return (standard NSTextField behavior)
    override func insertNewline(_ sender: Any?) {
        
        if let action {
            NSApp.sendAction(action, to: self.target, from: self)
        }
    }
    
    
    /// jump to the next key view by the Tab key (standard NSTextField behavior)
    override func insertTab(_ sender: Any?) {
        
        self.window?.selectNextKeyView(nil)
    }
    
    
    /// jump to the previous key view by the Tab key (standard NSTextField behavior)
    override func insertBacktab(_ sender: Any?) {
        
        self.window?.selectPreviousKeyView(nil)
    }
    
    
    /// swap `¥` with `\` if needed
    override func insertText(_ string: Any, replacementRange: NSRange) {
        
        // cast input to String
        var string = String(anyString: string)
        
        // swap `¥` with `\` if needed
        if UserDefaults.standard[.swapYenAndBackSlash] {
            switch string {
                case "\\":
                    string = "¥"
                case "¥":
                    string = "\\"
                default: break
            }
        }
        
        super.insertText(string, replacementRange: replacementRange)
    }
    
    
    override func responds(to aSelector: Selector!) -> Bool {
        
        // ignore text find action (standard NSTextField behavior)
        if aSelector == #selector(performTextFinderAction) {
            return false
        }
        
        return super.responds(to: aSelector)
    }
    
    
    
    // MARK: Actions
    
    /// clear current text
    @IBAction func clear(_ sender: Any?) {
        
        guard self.shouldChangeText(in: self.string.nsRange, replacementString: "") else { return }
        
        self.window?.makeFirstResponder(self)
        self.string = ""
        
        self.didChangeText()
    }
}
