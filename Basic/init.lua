a = true

function init_i2c_display()
     i2c.setup(0, 7, 5, i2c.SLOW)
     disp = u8g.ssd1306_128x64_i2c(0x3c)
end

function draw()
   disp:setFont(u8g.font_6x10)
   disp:drawStr( 30, 10, "KimchiC0n 3")
   disp:drawLine(0, 25, 128, 25);
   disp:setFont(u8g.font_chikita)
   disp:drawStr( 5, 40, "My name is Matt Oh")
end
  
function display()
  disp:firstPage()
  repeat
       draw()
  until disp:nextPage() == false
end

init_i2c_display()
display()

ws2812.init()

i=0
tmr.alarm(0, 200, 1, function()
    if i%3==0 then
        ws2812.write(string.char(255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0))
    end

    if i%3==1 then
        ws2812.write(string.char(0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0))
    end

    if i%3==2 then
        ws2812.write(string.char(0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255))
    end
    
    i = i + 1
end)
