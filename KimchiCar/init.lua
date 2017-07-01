

--DoitCar Ctronl Demo
--ap mode
--Created @ 2015/05/14 by Doit Studio
--Modified: null
--http://www.doit.am/
--http://www.smartarduino.com/
--http://szdoit.taobao.com/
--bbs: bbs.doit.am

-- 
--	GPIO Define
-- 
function initGPIO()
    gpio.mode(0,gpio.OUTPUT);
    gpio.write(0,gpio.LOW);

    gpio.mode(1,gpio.OUTPUT);
    gpio.write(1,gpio.LOW);
    gpio.mode(2,gpio.OUTPUT);
    gpio.write(2,gpio.LOW);

    gpio.mode(3,gpio.OUTPUT);
    gpio.write(3,gpio.LOW);

end

function setupAPMode()
    print("Ready to start soft ap")
    cfg={}
    cfg.ssid="DoitWiFi";
    cfg.pwd="12345678"
    wifi.ap.config(cfg)

    cfg={}
    cfg.ip="192.168.1.1";
    cfg.netmask="255.255.255.0";
    cfg.gateway="192.168.1.1";
    wifi.ap.setip(cfg);
    wifi.setmode(wifi.SOFTAP)

    str=nil;
    ssidTemp=nil;
    collectgarbage();

    print("Soft AP started")
end

--
--	Set up AP
--
setupAPMode();
print("Station mode enabled.")

--
--	Initialize GPIO
--
initGPIO();
print("GPIO initlaized.")


-- 
-- 	Variables for LED
-- 
ws2812.init();
local i, buffer = 0, ws2812.newBuffer(40, 4); 
buffer:fill(0, 0, 0, 0); 


--
--	Setup tcp server at port 9005
-- 
s=net.createServer(net.TCP,60);
s:listen(9005,function(c) 
    c:on("receive",function(c,d) 
      	print("TCPSrv:"..d)
		if string.sub(d,1,1)==" " then
			-- 
			-- Stop the car
			-- 

			-- useless, not working
			buffer:fill(0, 0, 0, 0); 

			gpio.write(0,gpio.LOW)
			gpio.write(1,gpio.LOW)
			gpio.write(2,gpio.LOW)
			gpio.write(3,gpio.LOW)
			c:send("ok\r\n");
		
		elseif string.sub(d,1,1)=="w" then
			-- 
			-- 	Ahead and turn on LEDz
			-- 
			tmr.create():alarm(50, 1, function()
				i = i + 1
				buffer:fade(2)
				buffer:set(i % buffer:size() + 1, 0, 0, 0, 255)
				ws2812.write(buffer)
				end)

			gpio.write(0,gpio.LOW)
			gpio.write(1,gpio.HIGH)
			gpio.write(2,gpio.HIGH)
			gpio.write(3,gpio.LOW)
			c:send("ok\r\n");

		elseif string.sub(d,1,1)=="s" then
			-- 
			-- 	Back
			--
			gpio.write(0,gpio.HIGH)
			gpio.write(1,gpio.LOW)
			gpio.write(2,gpio.LOW)
			gpio.write(3,gpio.HIGH)
			c:send("ok\r\n");

		elseif string.sub(d,1,1)=="a" then
			--
			-- Turn Left
			--
			gpio.write(0,gpio.LOW)
			gpio.write(1,gpio.LOW)
			gpio.write(2,gpio.LOW)
			gpio.write(3,gpio.HIGH)

			tmr.delay(300000)
			gpio.write(0,gpio.LOW)
			gpio.write(1,gpio.LOW)
			gpio.write(2,gpio.LOW)
			gpio.write(3,gpio.LOW)
			c:send("ok\r\n");		

		elseif string.sub(d,1,1)=="d" then
			-- 
			-- 	Turn right
			-- 
			gpio.write(0,gpio.LOW)
			gpio.write(1,gpio.HIGH)
			gpio.write(2,gpio.LOW)
			gpio.write(3,gpio.LOW)

			tmr.delay(300000)
			gpio.write(0,gpio.LOW)
			gpio.write(1,gpio.LOW)
			gpio.write(2,gpio.LOW)
			gpio.write(3,gpio.LOW)
			c:send("ok\r\n");
		
		else  
			print("Invalid Command:"..d);
			c:send("Invalid CMD\r\n");
		end;
		
		collectgarbage();
		end) --end c:on receive

    c:on("disconnection",function(c) 
		print("TCPSrv:Client disconnet");
		collectgarbage();
    end) 
    print("TCPSrv:Client connected")
end)