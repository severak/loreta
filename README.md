# Loreta

flexible digital synth (prototype)

## motivation

From all synths I have, I have most mixed feelings about AKAI MPK mini play. It's so close to being my ideal synth yet it's full of annoying bugs and unfinished ideas. If only there was an alternative firmware to it.

But there is more conceptual problem with it - it's not a synth. It's [built around](https://github.com/severak/akai-mpk-mini-play-guts) DREAM FRANCE SAM2635 synth-on-chip and it's in fact more like General-MIDI keyboard with somewhat editable sounds.

Therefore I decided to built my own synth:

## design goals

I want synth that is:

- **dirt-cheap** - available to everyone
- **portable** - easily transportable and not eating whole desk
- **flexible** - polyphonic, covering all General-MIDI sounds
- **software-based** - no custom chips or other unobtanium
- **opensource** - open to customizations and improvements

## prototype one

will be made of these things:

- spare Raspberry Pi
- DFRobot keypad-display combined hat
- menu driven UI because of that
- PatchboxOS
- synth programmed in Cabbage/CSound with python wrapper for interface

I have some ideas about structure of the synth, but this needs to be developed by testing those ideas.
