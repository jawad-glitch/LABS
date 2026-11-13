const Contract=require("../index");
const assert=require("assert");
const fs=require("fs");
const state=new Map();
const ctx={stub:{
 async getState(k){return state.get(k)||Buffer.from("");},
 async putState(k,v){state.set(k,v);},
 async deleteState(k){state.delete(k);}
}};
const contract=new Contract();

async function main(){
 const cases=[
  ["Create product",async()=>{
   const p=await contract.createProduct(ctx,"P1","Laptop",10,"Alice");
   assert.equal(p.quantity,10);
  }],
  ["Read product",async()=>{
   await contract.createProduct(ctx,"P1","Laptop",10,"Alice");
   assert.equal((await contract.readProduct(ctx,"P1")).name,"Laptop");
  }],
  ["Update quantity",async()=>{
   await contract.createProduct(ctx,"P1","Laptop",10,"Alice");
   assert.equal((await contract.updateQuantity(ctx,"P1",25)).quantity,25);
  }],
  ["Delete product",async()=>{
   await contract.createProduct(ctx,"P1","Laptop",10,"Alice");
   await contract.deleteProduct(ctx,"P1");
   await assert.rejects(()=>contract.readProduct(ctx,"P1"));
  }]
 ];
 const results=[];
 for(const [name,fn] of cases){
  state.clear();
  try{await fn();results.push({name,ok:true});console.log("PASS:",name);}
  catch(e){results.push({name,ok:false,error:e.message});console.log("FAIL:",name,e.message);}
 }
 const failures=results.filter(x=>!x.ok);
 const esc=s=>String(s).replace(/&/g,"&amp;").replace(/"/g,"&quot;").replace(/</g,"&lt;");
 const xml='<?xml version="1.0" encoding="UTF-8"?>\n'+
 `<testsuite name="inventory" tests="${results.length}" failures="${failures.length}">\n`+
 results.map(x=>`<testcase classname="InventoryContract" name="${esc(x.name)}">${x.ok?"":`<failure message="${esc(x.error)}"/>`}</testcase>`).join("\n")+
 "\n</testsuite>\n";
 fs.writeFileSync("test-results.xml",xml);
 console.log(`Tests: ${results.length-failures.length} passed, ${failures.length} failed`);
 if(failures.length) process.exitCode=1;
}
main();
