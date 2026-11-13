const express=require("express"),path=require("path"),app=express();
app.use(express.static(__dirname));
app.get("/fdc3-client.js",(q,s)=>s.sendFile(path.resolve(__dirname,"../../agent/fdc3-client.js")));
app.listen(3003,"0.0.0.0",()=>console.log("Trading app: http://localhost:3003"));
