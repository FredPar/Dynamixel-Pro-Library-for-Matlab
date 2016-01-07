#Matlab Library for the Robotis Dynamixel Pro servos

By Federico Parietti

--------------------------------------------------------------------------------------------------------------
Introduction


The Dynamixel Pro are high-torque servos manufactured by Robotis. Currently, for these servos there is no
official Robotis library for Matlab. I developed this library in order to control my robots
(http://federicoparietti.com/ ), and I wanted to publish it so that anyone using Matlab to control their
Dynamixel Pro can do it quickly and without reverse-engineering the Robotis C libraries
(http://support.robotis.com/en/techsupport_eng.htm#product/dynamixel_pro.htm ).

Note: the smaller Dynamixel servos are controlled with the DXL SDK, for which there are extensive online
resources (including Matlab code). However, the Dynamixel Pro servos use the DXL SDK 2.0, which is
substantially different from the DXL SDK. Any code developed for the old SDK will not work for the
Dynamixel Pro. This library has been developed to control the Dynamixel Pro using the DXL SDK 2.0. 

--------------------------------------------------------------------------------------------------------------
Required hardware


In order to use this library to control the Dynamixel Pro servos, you will need:
-	One or more Dynamixel Pro servomotors
-	24V power supply
-	USB2Dynamixel control device
-	Computer with a USB port

--------------------------------------------------------------------------------------------------------------
Instructions


Install the Robotis RoboPlus software.

Connect the Dynamixel Pro servos to the power supply and to the USB2Dynamixel device. Plug the USB2Dynamixel
into a USB port in your computer.

Using the RoboPlus software, test all of the connected Dynamixel Pro servos. Detailed instructions can be
found on the Robotis website:
http://www.robotis.com/download/doc/Dynamixel_pro/Dynamixel-Pro%20Quick%20Start_en.pdf 

Add the library folder to the Matlab path.

Open the file “A_StartAndTest_Example.m” to see some examples showing how to use the library functions to
write and read instructions to/from the Dynamixel Pro servos.

All functions are extensively commented.

Notice that the library contains two kind of functions:
-	simple Write and Read functions: to control one Dynamixel Pro servo at a time; multiple servos can
still be controlled by the same code (by accessing them one by one), but this quickly increases computing
time;
-	Sync_Write and Sync-Read functions: to control multiple Dynamixel Pro servos at the same time; these
functions are a little more complicated, but they are essential if you need to control many servos with a
faster sampling rate. 

--------------------------------------------------------------------------------------------------------------
License


This work is provided with a GNU GPL v3.0 license (see attached file).
Remember to credit the author of the library when using this work.
