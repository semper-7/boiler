-- net18b20
ds = 3
ips = "192.168.1.20"
rom = {}  
rom[1] = {0x28,0x61,0x64,0x11,0x8D,0x9E,0xD7,0xEA}
rom[2] = {0x28,0x61,0x64,0x11,0x8D,0xFB,0x01,0xC5}

function ds18b20()
 mes = ""
 ow.reset(ds)
 ow.write(ds, 0xCC, 1)
 ow.write(ds, 0x44, 1)
 ts = tmr.create(); ts:alarm(1000, tmr.ALARM_SINGLE, function()
  for i = 1, #rom do
   ow.reset(ds)
   ow.select(ds, rom[i])
   ow.write(ds,0xBE,1)
   data = ow.read_bytes(ds, 9)
   tn = "--.--"
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
   mes = mes..tn.."+"
  end
  print(mes)
  srv = net.createConnection(net.TCP, 0)
  srv:on("connection", function(s, _) s:send(mes) end)
  srv:connect(99,ips)
 end)
end

ow.setup(ds)
ta = tmr.create(); ta:alarm(30000, tmr.ALARM_AUTO, ds18b20)
ds18b20()
print("Temperature client started, "..node.heap().."mem free")
