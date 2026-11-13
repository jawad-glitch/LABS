class InventoryContract {
  async createProduct(ctx,id,name,quantity,owner) {
    const old = await ctx.stub.getState(id);
    if(old && old.length) throw Error("Product already exists");
    const p={id,name,quantity:Number(quantity),owner};
    if(!Number.isInteger(p.quantity)||p.quantity<0) throw Error("Invalid quantity");
    await ctx.stub.putState(id,Buffer.from(JSON.stringify(p)));
    return p;
  }
  async readProduct(ctx,id) {
    const d=await ctx.stub.getState(id);
    if(!d||!d.length) throw Error("Product not found");
    return JSON.parse(d.toString());
  }
  async updateQuantity(ctx,id,quantity) {
    const p=await this.readProduct(ctx,id);
    const n=Number(quantity);
    if(!Number.isInteger(n)||n<0) throw Error("Invalid quantity");
    p.quantity=n;
    await ctx.stub.putState(id,Buffer.from(JSON.stringify(p)));
    return p;
  }
  async deleteProduct(ctx,id) {
    await this.readProduct(ctx,id);
    await ctx.stub.deleteState(id);
    return true;
  }
}
module.exports=InventoryContract;
