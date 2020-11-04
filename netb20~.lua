-- net18b20
pin = 3
ow.setup(pin)
tn = "--.--"

function ds18b20()
 ow.reset(pin)
 ow.write(pin, 0xCC, 1)
 ow.write(pin, 0x44, 1)
 ts = tmr.create(); ts:alarm(1000, tmr.ALARM_SINGLE, function()
  ow.reset(pin)
  ow.write(pin, 0xCC, 1)
  ow.write(pin,0xBE,1)
  data = ow.read_bytes(pin, 9)
  if ow.crc8(string.sub(data,1,8)) == data:byte(9) then
   t = data:byte(1) + data:byte(2) * 256
   if data:byte(2)>128 then t = 65536-t end
   t1 = bit.rshift(t,4)
   t2 = bit.rshift(bit.band(t,0xf)*100,4)
   if data:byte(2)>128 then
    if t1<10 then
     tn = "-"..t1.."."..(t2/10)..(t2%10)
    else
     tn = "-"..(t1/10)..(t1%10)"."..(t2/10)
    end
   else
    if t1>99 then
     tn = "1"..((t1-100)/10)..((t1-100)%10).."."..(t2/10)
    else
     tn = (t1/10)..(t1%10).."."..(t2/10)..(t2%10)
    end
   end
  end
 end)
end

ta = tmr.create(); ta:alarm(30000, tmr.ALARM_AUTO, ds18b20)
ds18b20()
s=net.createServer(net.TCP, 10)
s:listen(99,function(c) c:send("Temperature NodeMCU is: "..tn.."\n"); c:close() end)
print(("Temperature server started (%d mem free, %s)"):format(node.heap(), wifi.sta.getip()))
