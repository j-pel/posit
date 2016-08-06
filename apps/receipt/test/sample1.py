#!/usr/bin/python

from escpos import *

Epson = escpos.Escpos(0x04b8,0x0202,0)
Epson.text("Hello World\n")
#Epson.image("logo.gif")
#Epson.barcode('1324354657687','EAN13',64,2,'','')
Epson.cut()
