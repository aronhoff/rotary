#!/usr/bin/env python3

from serial import Serial

def main():
    ser = Serial("/dev/ttyUSB0", 1000000)
    while True:
        while ser.read()[0] != 0xff:
            pass
        x = ser.read()[0]
        y = ser.read()[0]
        z = ser.read()[0]
        x = ((x << 0x10) | (y << 0x08) | z) << 2
        print(x)

if __name__ == "__main__":
    main()
