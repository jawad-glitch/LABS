const http = require('http');
const contractAddr = process.argv[2] || "";
const rpcUrl = "http://127.0.0.1:8545";
function rpc(method, params) {
  return new Promise((res, rej) => {
    const data = JSON.stringify({jsonrpc:"2.0", method, params, id:1});
    const req = http.request(rpcUrl, {method:"POST", headers:{"Content-Type":"application/json","Content-Length":data.length}}, r => {
      let b=""; r.on("data",c=>b+=c); r.on("end",()=>{try{res(JSON.parse(b))}catch(e){rej(e)}});
    });
    req.on("error",rej); req.write(data); req.end();
  });
}
(async () => {
  console.log("=== Comprehensive Smart Contract Test ===");
  const bn = await rpc("eth_blockNumber", []);
  console.log("Block:", parseInt(bn.result,16));
  const call = await rpc("eth_call", [{to: contractAddr, data: "0x6d4ce63c"}, "latest"]);
  console.log("get():", parseInt(call.result,16));
})();
