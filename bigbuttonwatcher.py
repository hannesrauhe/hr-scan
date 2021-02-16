#!/usr/bin/python3

import usb,sys,time

idVendor = 0x1d34
idProduct = 0x000d

fn_map = {22: "button down",21: "lid down", 23: "lid up"}

def findButton():
  for bus in usb.busses():
    for dev in bus.devices:
      if dev.idVendor == idVendor and dev.idProduct == idProduct:
        return dev
  return None

dev = findButton()
if dev == None:
  print("Cannot find panic button device")
  sys.exit(1)

handle = dev.open()
interface = dev.configurations[0].interfaces[0][0]
endpoint = interface.endpoints[0]

try:
  handle.detachKernelDriver(interface)
except Exception:
  # It may already be unloaded.
  pass

handle.claimInterface(interface)

last_event = 0x0
while True:
  # USB setup packet. I think it's a USB HID SET_REPORT.
  result = handle.controlMsg(requestType=0x21, # OUT | CLASS | INTERFACE
                             request= 0x09, # SET_REPORT
                             value= 0x0200, # report type: OUTPUT
                             buffer="\x00\x00\x00\x00\x00\x00\x00\x02")

  try:
    result = handle.interruptRead(endpoint.address, endpoint.maxPacketSize)
    if result[0]!=last_event:
      print(fn_map[result[0]])
      print([hex(x) for x in result])
      last_event = result[0]
  except Exception:
    # Sometimes this fails. Unsure why.
    pass
  time.sleep(endpoint.interval / float(1000))

handle.releaseInterface()
