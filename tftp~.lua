--tftp server
u = net.createUDPSocket()
u:listen(69)
u:on("receive", function(us, ud, port, ip)
 if ud:byte(2)==1 then
  fd=file.open(ud:match("%Z+",3))
  function get(i,j)
   j=j+1; if j==256 then j=0; i=i+1 end
   fr=fd:read(512); fl=#fr
   us:send(port,ip,"\0\3"..string.char(i)..string.char(j)..fr)
  end
  if fd then get(0,0) else us:send(port,ip,"\0\5\0\1".."File not found\0") end
 elseif ud:byte(2)==4 then
  if fl==512 then get(ud:byte(3),ud:byte(4)) else fd:close(); fd=nil end
 elseif ud:byte(2)==2 then
  if not fd then
   local f=ud:match("%Z+",3)
   file.remove(f)
   fd=file.open(f,"w")
   f=nil
  end
  us:send(port,ip,"\0\4\0\0")
 elseif ud:byte(2)==3 then
  if fd then fd:write(ud:sub(5)) end
  us:send(port,ip,"\0\4"..ud:sub(3,4))
  if #ud~=516 then fd:close(); fd=nil end
 end
end)
print(("Tftp server started (%d mem free, %s)"):format(node.heap(), wifi.sta.getip()))
