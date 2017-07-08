function init_i2c_display()
     i2c.setup(0, 7, 5, i2c.SLOW)
     disp = u8g.ssd1306_128x64_i2c(0x3c)
end

function draw(y1, y2)
   disp:setScale2x2()
   disp:setFont(u8g.font_chikita)
   disp:drawStr(0, y1, "KimchiC0n2017")
   disp:drawStr(0, y2, "051R15 :)")
end
  
function display(y1, y2)
  disp:firstPage()
  repeat
       draw(y1, y2)
  until disp:nextPage() == false
end

--init code
init_i2c_display()

y1 = 0
y2 = 10
i = 0
tmr.alarm(0, 500, 1, function()
   --Str scroll down
   y1 = y1 + 4
   y2 = y2 + 4
   display(y1, y2)
   if y1 > 21 then
      y1 = 0
   end
   if y2 > 64/2 then
      y2 = 30/3
   end
end)

