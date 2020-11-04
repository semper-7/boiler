--Telnet server
s=net.createServer(net.TCP, 30)
s:listen(23,function(c)
 function so(str) if(c~=nil) then c:send(str) end end
 node.output(so, 0)
  c:on("receive",function(c,l)
   local r=1
   if l:sub(1,4)=="exit" then
    c:close(); node.output(nil)
   elseif l:sub(1,2)=="ls" then
    c:send("Filename\tSize\n")
    for f,s in pairs(file.list()) do c:send(f.."   \t"..s.."\n") end
   elseif l:sub(1,2)=="rm" then
    file.remove(l:sub(4,-3))
   elseif l:sub(1,3)=="cat" then
    fd = file.open(l:sub(5,-3))
    if fd then c:send(fd:read()); fd:close() end
   elseif l:sub(1,3)=="mem" then
    c:send("Mem free: "..node.heap().."\n")
   elseif l:sub(1,6)=="reboot" then
    c:close(); tt=tmr.create()
    tt:alarm(500,tmr.ALARM_SINGLE,node.restart)
   else node.input(l); r=nil
   end
   if r then node.input("\r"); r=nil end
  end)
 c:on("disconnection",function(c) node.output(nil) end)
 c:send(("Welcome to NodeMCU (%d mem free)\n"):format(node.heap()))
 node.input("\r")
end)
print(("Telnet server started (%d mem free, %s)"):format(node.heap(), wifi.sta.getip()))
