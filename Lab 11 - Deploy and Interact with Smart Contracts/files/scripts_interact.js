module.exports = async function(callback) {
  try {
    const instance = await artifacts.require("SimpleStorage").deployed();
    const before = await instance.get();
    console.log("BEFORE:", before.toString());
    await instance.set(100);
    const after = await instance.get();
    console.log("AFTER:", after.toString());
    await instance.increment();
    const incr = await instance.get();
    console.log("INCR:", incr.toString());
    const info = await instance.getInfo();
    console.log("INFO_VALUE:", info.value.toString());
    console.log("INFO_ADDR:", info.contractAddress);
    callback();
  } catch(e) { console.error("ERR:", e.message); callback(e); }
};
