--Init
uart.write(0, "Connect to AP >>")
wifi.setmode(wifi.STATION)
wifi.sta.config {ssid="ROSTELECOM_B429", pwd="F5D2129D", save=false}
t = tmr.create(); t:alarm(2000, tmr.ALARM_AUTO, function()
 if (wifi.sta.status() == wifi.STA_GOTIP) then
  t:unregister()
  t=nil
  print(" Done.\nIP:",wifi.sta.getip())
  for f in pairs(file.list()) do
   if f:sub(-5,-1) == "~.lua" then dofile(f) end
  end
 else
  uart.write(0,".")
 end
end)
collectgarbage()
