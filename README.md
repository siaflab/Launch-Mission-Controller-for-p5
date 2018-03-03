# Launch-Mission-Controller-with-p5

Launch-Mission-Controller is sample program that manages countdown for launch event of high altitude balloon while playing music with SonicPi. By writing a time stamp in the CSV file, it will automatically read the mission at instructed time by speech synthesis. This sketch supports OSC to communicate with SonicPi, so oscp5 and texttospeech library are required.


## DEPENDENCIES

You need to install the following software:

- [Processing](https://processing.org/)
- [SonicPi](http://sonic-pi.net/)
- [Petal](https://github.com/siaflab/petal)

You need to import the following libraries to run this sketch:

- [oscp5](https://github.com/sojamo/oscp5)
- [texttospeech in processing](http://www.frontiernerds.com/text-to-speech-in-processing)

You need to move the tick folder under "petal/Dirt-Samples/".
