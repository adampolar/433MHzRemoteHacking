local webpagep1 = 
[[<html>
<head>
<style>
.buttons {width: 32%;margin: 5% auto;background-color:#44c767;
-moz-border-radius:28px;-webkit-border-radius:28px;border-radius:28px;
border:1px solid #18ab29;display:inline-block;cursor:pointer;color:#ffffff;
font-family:Arial;font-size:17px;padding:16px 31px;
text-decoration:none;text-shadow:0px 1px 0px #2f6627;}
.buttons:active {posiition:relative;top:1px;}
.buttons[data-button="b"] { border: 1px solid rgb(165, 17, 192);
text-shadow: rgb(155, 20, 179) 0px 1px 0px;
background-color: rgb(193, 35, 222);}
.buttons[data-button="c"] { border: 1px solid rgb(35, 160, 235);
    text-shadow: rgb(38, 54, 102) 0px 1px 0px;
    background-color: rgb(45, 171, 249);}
body{padding: 0 10%;}
</style>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>]]
local webpagep2 = [[
<button class="buttons on" data-button="a">a on</button>
<button class="buttons off" data-button="a">a off</button>
<button class="buttons toggle" data-button="a">a toggle</button>
<button class="buttons on" data-button="b">b on</button>
<button class="buttons off" data-button="b">b off</button>
<button class="buttons toggle" data-button="b">b toggle</button>
<button class="buttons on" data-button="c">c on</button>
<button class="buttons off" data-button="c">c off</button>
<button class="buttons toggle" data-button="c">c toggle</button>
<script src="https://code.jquery.com/jquery-2.2.0.min.js"></script>
<script>
$(function(){
$('.on, .off, .toggle').click(function(){
    $.ajax('/func' + $(this).attr('class').split(' ')[1] +  '/' + $(this).data('button'));
});
});</script>
</body>
</html>]]

local header = 
[[HTTP/1.1 200 OK
Server: WiFiMCU
Content-Type:text/html
Content-Length: ]] .. (string.len(webpagep1 .. webpagep2)) .. [[

Connection: close]]..'\r\n\r\n'

local retryattempts = 3

srv=net.createServer(net.TCP) 
srv:listen(80,function(conn) 
    conn:on("receive",function(conn,payload)
        if string.find(payload, 'favicon.ico') then
            conn:send("nope")
            return
        end
        print(payload)
        local func, letter = string.match(payload, '/func(%a+)/(%a+)')
        print(func)
        if func == 'toggle' then        
            for i=0, retryattempts do
                radio.emitControl(radio.sequences[letter].on, 3)
            end
            for i=0, retryattempts do
                radio.emitControl(radio.sequences[letter].off, 3)
            end
        elseif func == 'on' or func == 'off' then
            for i=0, retryattempts do
                radio.emitControl(radio.sequences[letter][func], 3)
            end
        end
    --    conn:send(response)
      --  conn:send(webpagep1)
        --conn:send(webpagep2)

        local response = {header, webpagep1, webpagep2}
        local function sender (sck)
            if #response>0 then 
                sck:send(table.remove(response,1))
            else 
                sck:close()
            end
        end
        conn:on("sent", sender)
        sender(conn)
    end) 
end)
