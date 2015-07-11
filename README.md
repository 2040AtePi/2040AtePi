#2040 Ate Pi

2040 Ate Pi is a port of the game **2048** created by Gabrielle Cirulli, fully written in ARM11 Assembly for **Raspberry Pi**. 

It also includes a custom-built AI that can be improved. It is compatible with Revision B, and will be ported to version 2. 

Feel free to contribute!

### Gameplay

The main functionality of 2048 is implemented, with a graphical interface.

The recommended configuration is to use a [joystick][1] coupled with two buttons for Reset and AI mode. See below for GPIO pin details.

### Installation
- Install [`gcc-arm-none assembler`][2]
- Run `make` in your Terminal
- A `kernel.img` file will be generated. Replace the `kernel.img` file with it on the `BOOT` partition of the SD card of the Raspberry Pi (assuming Raspbian is installed). Make sure to backup your `kernel.img` file before. 

####Pins

| Button       |Pin   |
|:------------:|:----:|
| ↑            | 18   |
| ↓            | 22   |
| ←            | 23   |
| →            | 17   |
|Enable AI Mode| 24   |
|Reset Game    | 25   |

###Hardware

Connect the Raspberry Pi to an HDMI display. 

Our configuration uses a [joystick][1] and two buttons for Reset and AI mode (see below). The GPIO pins used can be changed easily in `button.s`.



###Artificial Intelligence
The game includes an Artificial Intelligence mode, which is toggle-able by one of the GPIO pins.

The AI used a randomized statistical approach to play the game. It calculates which way to move the board based on the following algorithm:
 
 1. Save the state of the current board
 2. Move up
 	a. Play random moves until the game ends
 	b. Calculate the score
  	c. Repeat steps 2.a. to 2.c 1000 times.
 	d. Calculate the average score obtained
 3. Do step 2. for Move left, Move down and Move right calculating the average score obtained for each direction.
 4. Move the original board in the direction with the highest average score. The score calculation mentioned in the algorithm is a slightly modified from the original game. In our version, when two tiles merge, we add the sum of their values to the score.

###Improvement
There is always room for improvement. Here are some ideas:
  
  - Adding scoring
  - Improving animations and User Interface
  - Compatibility for other hardware
  
###Generating Tiles from Images
To generate the assembly code for displaying the numbers, use our `tile_generator`.

All you need to do is put black and white png images in the `images/` directory and run `genscript.sh`. 

Note that the size of the images has to be 150x150 pixels and their names have to be of the form <number>.png where number is a power of 2 between 2 and 131072.

###Thanks to
Imperial College London and Raspberry Pi for Best ARM Final Year Project Prize (Year 1).

Cambridge University for providing a Raspberry Pi Graphics [tutorial][4].

Uddhav Vaghela, Paul Balaji, Amin Karamlou.

###Contributing
Franklin Schrans, Jacek Burys, Saurav Mitra, Srikrishna Subrahmanyam

###Disclaimer
This project is protected under the [MIT License][3].

[1]:http://www.adafruit.com/products/480
[2]:https://launchpad.net/gcc-arm-embedded
[3]:LICENSE
[4]:https://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/
