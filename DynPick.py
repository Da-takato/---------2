#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time
import serial
import struct

class DynPick:
    # LPFとゼロ点の設定は未実装，他は実装済み
    ver = '23.9.26'
    is_started = 0
    force = [0, 0, 0]
    def __init__(self, port):
        self.ser = serial.Serial(
            port,
            baudrate = 921600,
            # parity = serial.PARITY_NONE,
            # bytesize = serial.EIGHTBITS,
            # stopbits = serial.STOPBITS_ONE,
            # timeout = None,
            # xonxoff = 0,
            # rtscts = 0,
            )
        self.stop_continuous_read()
    def __del__(self):
        self.close()
    def close(self):
        if self.ser.is_open:
            self.stop_continuous_read()
            self.ser.close()
    def show_firmware_version(self):
        time.sleep(0.100)
        self.ser.flush()
        self.ser.write([ord('V')])
        time.sleep(0.100)
        in_waiting = self.ser.in_waiting
        if in_waiting > 0:
            print(self.ser.read(in_waiting).decode())
    def show_sensitivity(self):
        time.sleep(0.100)
        self.ser.flush()
        self.ser.write([ord('p')])
        time.sleep(0.100)
        in_waiting = self.ser.in_waiting
        if in_waiting > 0:
            print(self.ser.read(in_waiting).decode())
    def read_temperature(self):
        time.sleep(0.100)
        self.ser.flush()
        self.ser.write([ord('T')])
        time.sleep(0.100)
        in_waiting = self.ser.in_waiting
        if in_waiting > 0:
            recv = self.ser.read(in_waiting)
            data = data = struct.unpack('=4s2B', recv)
            return float(int(data[0].decode(),16))/16.0
        else:
            return None

    def read_once(self):
        self.ser.write([ord('R')])
        time.sleep(0.020)
        in_waiting = self.ser.in_waiting
        if in_waiting == 27:
            recv = self.ser.read(in_waiting)
            data = struct.unpack('=B4s4s4s4s4s4s2B', recv)[1:7]
            return self.bytesToDouble(data)
        else:
            print('No available data.')
            return [None, None, None]

    def start_continuous_read(self):
        self.ser.flush()
        self.ser.write([ord('S')])
        while self.ser.in_waiting < 27*2:
            time.sleep(1e-3)
        self.is_started = 1
        self.force = self.read_continuous()
    def stop_continuous_read(self):
        self.ser.write([ord('E')])
        time.sleep(0.020)
        self.ser.flush()
        self.is_started = 0
    def read_continuous(self):
        # 13	0D	CR
        # 10	0A	LF
        if self.is_started:
            in_waiting = self.ser.in_waiting
            if in_waiting >= 27*2:
                recv = self.ser.read(in_waiting)
                if 0x0A in recv:
                    ii = recv.rfind(0x0A)
                    recv = recv[ii-27+1:ii+1]
                    if recv[25] == 0x0D:
                        data = struct.unpack('=B4s4s4s4s4s4s2B', recv)[1:7]
                        self.force = self.bytesToDouble(data)
                    # self.ser.flush()
                return self.force
            else:
                return self.force
        else:
            print('Data send is NOT started.')
            return [None, None, None]

    # @classmethod
    @staticmethod
    def bytesToDouble(argBytes6):
        sensitivity = [65.470,65.440,65.080,1638.500,1639.250,1640.750]
        zeroOutput = [0x2000, 0x2000, 0x2000, 0x2000, 0x2000, 0x2000]
        retInt6 = [int(argBytes6[0].decode(),16), int(argBytes6[1].decode(),16), int(argBytes6[2].decode(),16),
                   int(argBytes6[3].decode(),16), int(argBytes6[4].decode(),16), int(argBytes6[5].decode(),16) ]
        retDouble6 = [ float(retInt6[0]-zeroOutput[0])/sensitivity[0],
                       float(retInt6[1]-zeroOutput[1])/sensitivity[1],
                       float(retInt6[2]-zeroOutput[2])/sensitivity[2],
                       float(retInt6[3]-zeroOutput[3])/sensitivity[3],
                       float(retInt6[4]-zeroOutput[4])/sensitivity[4],
                       float(retInt6[5]-zeroOutput[5])/sensitivity[5] ]
        return retDouble6

if __name__ == '__main__':
    # ls -l /dev/tty.* # for macOS
    # dpick = DynPick('/dev/tty.usbserial-AU02EQ8G')
    # dpick = DynPick('/dev/tty.usbserial-AU05U761')    
    # See device manager for windows OS
    dpick = DynPick('COM4')

    dpick.show_firmware_version()
    dpick.show_sensitivity()
    print(str(dpick.read_temperature())+'(deg C)')

    data = dpick.read_once()
    print(data)
    print("[N], [Nm]")
    # ret, elapsed_time = timeMesurement(dpick.read_once, 0)
    # print(ret)
    # print("Spent time = %.3f(msec)" % (elapsed_time*1000))

    # dpick.start_continuous_read()
    # # data = dpick.read_continuous()
    # ret, elapsed_time = timeMesurement(dpick.read_continuous, 0)
    # print(ret)
    # print("Spent time = %.3f(msec)" % (elapsed_time*1000))

    # start = time.time()
    # while (time.time() - start)<1 :
    #     ret, elapsed_time = timeMesurement(dpick.read_continuous, 0)
    #     print(ret)
    #     print("Spent time = %.3f(msec)" % (elapsed_time*1000))
