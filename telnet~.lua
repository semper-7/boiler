--Telnet server
s=net.createServer(net.TCP, 30)
s:listen(23,function(c)
 node.output(function(s) c:send(s) end, 0)
  c:on("receive",function(c,l)
   local r=1
   if l:sub(1,4)=="exit" then
    c:close(); node.output(nil)
   elseif l:sub(1,2)=="ls" then
    c:send("Filename\tSize\n")
    for f,s in pairs(file.list()) do c:send(f.."   \t"..s.."\n") end
   elseif l:sub(1,3)=="rm " then
    file.remove(l:match("%S+",4))
   elseif l:sub(1,4)=="cat " then
    fd = file.open(l:match("%S+",5))
    if fd then c:send(fd:read()); fd:close() end
   elseif l:sub(1,3)=="mem" then
    c:send("Mem free: "..node.heap().."\n")
   elseif l:sub(1,6)=="reboot" then
    c:close(); tt=tmr.create()
    tt:alarm(500,tmr.ALARM_SINGLE,node.restart)
   elseif l:find("^[%w-_]+\.lua\r") then
    local f=l:match("%S+")
    if file.exists(f) then dofile(f) end
    f=nil
   else node.input(l); r=nil
   end
   if r then node.input("\r"); r=nil end
  end)
 c:on("disconnection",function(c) node.output(nil) end)
 c:send(("Welcome to NodeMCU (%d mem free)\n"):format(node.heap()))
 node.input("\r")
end)
print(("Telnet server started (%d mem free, %s)"):format(node.heap(), wifi.sta.getip()))
