//
//  main.swift
//  ghidraLauncher
//
//  Created by my_anonymous on 2022/5/27.
//

import Foundation
import Cocoa
import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    override init() {
        self.window = NSWindow(
                contentRect: CGRect(x: 0, y: 0, width: 800, height: 500),
                styleMask: [.closable, .titled],
                backing: .buffered,
                defer: false)
        super.init()
        let bundle_dirs :URL =  Bundle.main.resourceURL!
        let ghidra_dir:URL = bundle_dirs.appendingPathComponent("ghidra", isDirectory: true)
        let ghidra_run:URL = ghidra_dir.appendingPathComponent("ghidraRun", isDirectory: false)
        if FileManager.default.fileExists(atPath: ghidra_run.path) {
            self.shell(ghidra_run.path)
            NSApp.terminate(self)
        }
        else {
            let width: CGFloat = self.window.frame.width
            let height: CGFloat = 30
            var frame = self.window.frame
            frame.origin.x = (frame.width - width) / 2
            frame.origin.y = (frame.height - height) / 2
            frame.size = CGSize(width: width, height: height)
            let label = NSTextField(frame: frame)
            label.font = .systemFont(ofSize: 15, weight: NSFont.Weight(rawValue: 3))
            label.stringValue = "Please put \"ghidra\" to the folder location \"ghidraLauncher.app/Resource/\""
            label.alignment = .center
            label.isBezeled = false
            label.isEditable = false
            label.isSelectable = false
            label.drawsBackground = false
            window.contentView?.addSubview(label)
            window.makeKeyAndOrderFront(nil)
        }
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {

    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    func shell(_ args: String...) -> String {
        let task = Process()
        task.launchPath = "/bin/bash/"
        task.arguments = args
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output: String = String(data: data, encoding: .utf8) else { return "" };
        return output
    }
}


let delegate = AppDelegate()
NSApplication.shared.delegate = delegate
NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

