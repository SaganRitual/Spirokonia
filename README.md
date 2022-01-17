# Spirokonia

[![version](https://img.shields.io/badge/version-v0.2-blue?style=plastic)](https://www.github.com/SaganRitual/Spirokonia)
[![platform](https://img.shields.io/badge/platform-ios%20%7C%20macos-lightgrey?style=plastic)](https://www.github.com/SaganRitual/Spirokonia)

A toy, a virtual "spirograph", inspired by YouTuber Sort of School's #SoME1 [video](https://youtu.be/n-e9C8g5x68), which was inspired by YouTuber 3Blue1Brown's #SoME1 [challenge](https://youtu.be/ojjzXyQCzso).

Set the number of spinning spheres and their speed, color density and length of display for a zen like visual experience.

# Installation

Requirements:

- MacOS Monterey V12.1
- Xcod V13.2.1

* Clone the project
* Double-click the Spirokonia.xcsworkspace file to open in Xcode
* Propeller+b to build and then click the Run icon in Xcode
* Build one of the Spirokonia targets. The other targets are for developing new components. (DAB note: I'm not sure what it means to "build one of the Spirokonia targets" -- is this describing what is detailed in the bullet point just below?)
* Prefer the iPad target in landscape orientation or the macOS target. It does run on iPhone, but I haven't yet figured out a user-friendly way to present the views. (DAB note: direct the user to where you select the ipad target and and landscape orientation in xcode)


# How to use the controls -- coming soon

<img src="Screenshot.v0.2.gif" height=512 />

The SpiroZen controls are located in the left-side control panel and allow you to set the number of spheres that display, their speed, color density, and color display to your liking.

The outtermost blue sphere's controls can be configured using the Main controls. Use the Tumblers controls to configure the four other spheres (purple, red, yellow, and green spheres) that spin within the outermost blue sphere.


## Main

The set of controls under the Main heading control the outermost blue circle in terms of spinning, x, y, and z.

The top horizontal row of controls under the Main header include the following buttons:

- Stop: Stops the outermost ring from spinning. You can tell if the ring has stopped spinning when the blue radius line stops moving. Note that the inner rings and their actions continue; only the outer ring is stopped/started by this button.
- Play: Starts the outermost ring spinning. You can tell if the ring has started spinning when the blue radius line starts moving and the design drawn on screen changes. Note that the innter rings and their state (spinning or not spinning) are not affected by pressing the Play button for the outermost ring.
- Visbility: Displays/hides the outermost ring on the screen.

The three vertical controls uder the top control row include the following buttons:

- Speed: The slider controls the speed of the outermost ring's spin (left is slowest, right is faster/fastest). Click the Speed button to select your slider's speed measurement increments (infinity, 2, 3, 5, 4, 6, 10). Note that setting the spinning speed will affect all the inner rings.
- Scale: Move the slider to control the scale of the rings' display (left reduces the size/scale displayed, and right increases the size/scale dislayed). Note that a scale of 1.0 will automatically size the scale display to fit perfectly in your device's screen and controls the scale of all the inner rings as well. As with the Speed button, you can click the Scale button to select your slider's scale measurement increments (infinity, 2, 3, 5, 4, 6, 10).
- Dot Density: Move the slider to control the drawn display of the spinning circles (left reduces density, so you see the individual dots in the design, and right increases the density to display more of a solid line). Note that your speed setting will also affect the dispaly, i.e. a low density setting with a high speed setting may also display a more solid line effect.


## Tumblers  