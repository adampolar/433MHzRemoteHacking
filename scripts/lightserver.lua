local webpage = 
[[<html>
<head>
<style>
.buttons {width: 100%;margin: 5% auto;background-color:#44c767;
-moz-border-radius:28px;-webkit-border-radius:28px;border-radius:28px;
border:1px solid #18ab29;display:inline-block;cursor:pointer;color:#ffffff;
font-family:Arial;font-size:17px;padding:16px 31px;
text-decoration:none;text-shadow:0px 1px 0px #2f6627;}
.buttons:active {position:relative;top:1px;}
body{padding: 0 10%;}
</style>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
<button class="buttons" id="lighton">on</button>
<button class="buttons" id="lightoff">off</button>
<script src="https://code.jquery.com/jquery-2.2.0.min.js"></script>
<script>
$(function(){
$('#lighton').click(function(){
    $.ajax('/lighton');
});
$('#lightoff').click(function(){
    $.ajax('/lightoff');
});
});</script>
</body>
</html>]]

local response = 
[[HTTP/1.1 200 OK
Server: WiFiMCU
Content-Type:text/html
Content-Length: ]] .. (string.len(webpage)) .. [[

Connection: close]]..'\r\n\r\n'.. webpage

local retryattempts = 3

srv=net.createServer(net.TCP) 
srv:listen(80,function(conn) 
    conn:on("receive",function(conn,payload)
        if string.find(payload, 'favicon.ico') then
            conn:send("piss off")
            return
        end
        if string.find(payload, 'lighton') then
            for i=0, retryattempts do
                radio.emitControl(radio.sequences.a.on, 3)
            end
        end
        if string.find(payload, 'lightoff') then
            for i=0, retryattempts do
                radio.emitControl(radio.sequences.a.off, 3)
            end
        end
        conn:send(response)
    end) 
end)
