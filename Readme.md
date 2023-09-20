<!-- HEADER -->
<img src="./.assets/AppIcon.png" width="60" align="right"/>
<h1>Voice Recognizer App</h1>

[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg?longCache=true&style=flat&logo=swift)][Swift]
[![iOS](https://img.shields.io/badge/iOS-16.6+-lightgrey.svg?longCache=true&?style=flat&logo=apple)][iOS]
[![](https://img.shields.io/badge/Twitter-%231DA1F2.svg?&style=flat&logo=twitter&logoColor=white)][Twitter]




<!-- BODY -->
## Frameworks
- [SwiftUI framework](https://developer.apple.com/documentation/swiftui)
- [AV Foundation framework](https://developer.apple.com/documentation/avfoundation/)
- [Speech framework](https://developer.apple.com/documentation/speech/)


## External dependencies
- None


## Description
VoiceRecoginition App is a mobile app that can use voice recognition commands and transform them into data that will be shown on the screen.

### Voice Commands Interpretation
Our objective is to convert spoken language into actionable commands. Each command will consist of a specified action, along with associated input parameters and output values in the following format: `{ "command": "name", "value": "output" }`.

Commands will be initiated with a keyword, followed by relevant parameters. Parameters will always be numerical and single-digit. In the event of any non-numeric words being detected, they should be disregarded, with the sole exception being the `Reset`, `Back` or `Done` command, which should bypass this rule and transition the module into further actions.

We will operate in two states: "waiting for command" and "listening to the current command." When a user pronunces a command keyword, the module will switch from "waiting for command" to "listening to the current command." In the absence of a recognized command keyword, it will disregard the spoken words."

### Spoken commands
- **CODE:** adds a single integer into the parameters list.
- **COUNT:** produces a row of integers into the paremeters list.
- **BACK:** deletes the current parameters under the active command but not the command.
- **RESET:** deletes both, the current parameters and active command and goes back to waiting for a new command.
- **DONE:** creates a new data output and attaches it to the list when there is at least one parameter and an active command on the selector.

### Additional features
The app starts listening for commands at its launch, right after user permissions have been grantes but there is a button at the top right corner to manually start/stop the speech recognizer engine.

On the other hand, any data output presented on the screen can be deleted from the list with a swipe gesture.

## Preview
This recording goes through the implemented commands and user interface.

<p align="left">
	<img src="./.assets/ScreenRecording.gif" height="500"/>
</p>




<!-- FOOTER -->
<!-- Permanent links -->
[Swift]: https://www.swift.org
[iOS]: https://developer.apple.com/ios/
[Twitter]: https://twitter.com/TomEstelrich