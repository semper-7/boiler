-- boiler
rom = {}
rom[1] = {0x28,0x13,0x39,0x0E,0x06,0x00,0x00,0xAF}
rom[2] = {0x28,0x8A,0xB8,0x0C,0x06,0x00,0x00,0x89}
rom[3] = {0x28,0xA3,0x98,0x0D,0x06,0x00,0x00,0xDE}
rom[4] = {0x28,0xA7,0xC6,0x0C,0x06,0x00,0x00,0xBA}
rom[5] = {0x28,0x9F,0xA9,0x0E,0x06,0x00,0x00,0x8F}
rom[6] = {0x28,0xB2,0xEE,0xA9,0x04,0x00,0x00,0xAB}
rom[7] = {0x28,0x61,0x64,0x11,0x8D,0x8C,0xFF,0x76}
rom[8] = {0x28,0xF3,0x3D,0xA9,0x04,0x00,0x00,0xF9}
ip = "192.168.1.22"
tnet = "--.--"
host = "yfb7905i.bget.ru"
cfg = {25 32 42 45 48 96};
p = {0,0,0,0,0,0,0,0}
key,tx = 0,0

function sendtemp()
 inet = false
 srv = net.createConnection(net.TCP, 0)
 srv:on("receive", function(sck, c)
  if (#c==200) then
   s = c:sub(-22)
   print("CFG: "..s)
   for i = 1, 6 do
    h = tonumber(s:sub(i*3+3,i*3+4))
    if h~=nil then cfg[i] = h end
   end
   ind = "^~~"..s:sub(1,1)..string.char(bit.band(s:byte(2,2),0x1f))..s:sub(3,4)..ind:sub(8,12)
   print(ind)
   inet = true
  end
 end)
 srv:on("connection", function(sck, c)
  sck:send("GET /log.php?var="..var.." HTTP/1.0\r\nHost: "..host.."\r\nUser-Agent: Mozilla/5.0\r\n\r\n")
 end)
 srv:connect(80,host)
 e = tmr.create(); e:alarm(4000, tmr.ALARM_SINGLE, function() if not inet then print(ind) end end)
end

function indt()
 ind = "^~~".."0"+tx.."   "
 if r >= 4 then ind = ind.."\127"
 elseif r == 8 then ind = ind.."z"
 else ind = ind.." " 
 end
 for j=tx*6+1,tx*6+5 do
  m = var:sub(j,j)
  if m == '.' then
  elseif m == '-' then ind = ind.."'"
  elseif var:sub(j+1,j+1) == '.' then ind=ind..string.char(bit.band(var:byte(j,j),0x1f))
  else ind=ind..m
  end
 end
end

function keyfunc()
 if key~=0 then key=key-1
 elseif gpio.read(6) == 0 then
  tx = tx+1
  if tx == 9 then tx = 0 end
  indt()
  print(ind)
  key=10
 end
end

function main()
 var = ""; r = 0
 ow.reset(3)
 ow.write(3, 0xCC, 1)
 ow.write(3, 0x44, 1)
 g = tmr.create(); g:alarm(1000, tmr.ALARM_SINGLE, function()
  for i = 1, 8 do
   ow.reset(3)
   ow.select(3, rom[i])
   ow.write(3,0xBE,1)
   data = ow.read_bytes(3, 9)
   v = "--.--"
   if ow.crc8(data:sub(1,8)) == data:byte(9) then
    x = data:byte(1) + data:byte(2) * 256
    if data:byte(2)>128 then x = 65536-x end
    y = bit.rshift(x,4)
    p[i] = y
    z = bit.rshift(bit.band(x,0xf)*100,4)
    if data:byte(2)>128 then
     if y<10 then v = ("-"..y.."."..(z/10)..(z%10))
     else v = ("-"..(y/10)..(y%10)"."..(z/10))
     end
    elseif y>99 then v = ("1"..((y-100)/10)..((y-100)%10).."."..(z/10))
    else v = ((y/10)..(y%10).."."..(z/10)..(z%10))
    end
   end
   var = var..v.."+"
  end
  if p[1] >= cfg[6] then r=8; print("OVERHEATING!!!\r\n")
  else
   FI = (p[7] >= cfg[5]) or ((p[7] >= cfg[2]) and (p[1] < cfg[5]))
   PO = (p[8] < p[1]) and (p[8] < cfg[1]) and (not FI or (p[6] >= cfg[3]))
   PB = FI and (p[6] < cfg[5]) and (not PO or (p[6] < cfg[4])) and ((p[8] < cfg[1]) or (p[6] < cfg[1]))
   if FI then r = 4 end
   if PO then r = r + 2; gpio.write(2, gpio.HIGH) else gpio.write(2, gpio.LOW) end
   if PB then r = r + 1; gpio.write(1, gpio.HIGH) else gpio.write(1, gpio.LOW) end
  end
  var=var..tnet.."+"..r
  tnet = "--.--"
  print(var)
  indt()
  sendtemp()
 end)
end

function test()
 print("^~~12345678"..r)
 if bit.band(r,2)~=0 then gpio.write(2, gpio.HIGH)
 else gpio.write(2, gpio.LOW)
 end
 if bit.band(r,1)~=0 then gpio.write(1, gpio.HIGH)
 else gpio.write(1, gpio.LOW)
 end
 r=r+1
 if r==4 then r=0 end
end

print("\r\nBoiler-auto started")
ow.setup(3)
gpio.mode(1, gpio.OUTPUT)
gpio.mode(2, gpio.OUTPUT)
gpio.mode(6, gpio.INPUT, gpio.PULLUP)
if gpio.read(6) == 0 then
 print("^~~123456789")
 t = tmr.create(); t:alarm(2000, tmr.ALARM_AUTO, test)
else
 t = tmr.create(); t:alarm(30000, tmr.ALARM_AUTO, main)
 k = tmr.create(); k:alarm(20, tmr.ALARM_AUTO, keyfunc)
 s=net.createServer(net.TCP, 0)
  s:listen(99,function(c)
   c:on("receive",function(c,l)
    print(l)
    if l:sub(1,12)==ip then tnet=l:sub(14,18)
    end
    c:close()
   end)
  end)
 main()
end
