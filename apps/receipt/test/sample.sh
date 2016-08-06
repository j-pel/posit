#!/bin/bash

# ESC = "\x1b";
# GS="\x1d";
# NUL="\x00";

#/* Output an example receipt */
echo "\x1b@" >> /dev/usb/lp0 #// Reset to defaults
echo "\x1bE\x01" >> /dev/usb/lp0 #// Bold
echo "Ozio caff\x82" >> /dev/usb/lp0 #// Company with special chars
echo "\x1bE\x00" >> /dev/usb/lp0 #// Not Bold
echo "\x1bd\x01" >> /dev/usb/lp0 #// Blank line
echo "Gracias por su compra\n" >> /dev/usb/lp0 #// Print text
echo "\x1bd\x04" >> /dev/usb/lp0 #// 4 Blank lines

#/* Bar-code at the end */
echo "\x1ba\x01" >> /dev/usb/lp0 #// Centered printing
echo "\x1dk\x04987654321\x00" >> /dev/usb/lp0 #// Print barcode
echo "\x1bd\x01" >> /dev/usb/lp0 #// Blank line
echo "987654321\n" >> /dev/usb/lp0 #// Print number
echo "\x1dV\x41\x03" >> /dev/usb/lp0 #// Cut
