import sys, json, urllib.request
from eth_account import Account
def rpc(m,p):
    d=json.dumps({"jsonrpc":"2.0","method":m,"params":p,"id":1}).encode()
    return json.loads(urllib.request.urlopen(urllib.request.Request("http://127.0.0.1:8545",data=d,headers={"Content-Type":"application/json"}),timeout=5).read())
k,to,chain=sys.argv[1],sys.argv[2],int(sys.argv[3])
a=Account.from_key(k)
n=int(rpc("eth_getTransactionCount",[a.address,"pending"])["result"],16)
tx={"nonce":n,"gasPrice":0,"gas":21000,"to":to,"value":1,"data":b"","chainId":chain}
s=a.sign_transaction(tx)
raw=s.rawTransaction if hasattr(s,"rawTransaction") else s.raw_transaction
h=raw.hex()
h=h if h.startswith("0x") else "0x"+h
print(json.dumps(rpc("eth_sendRawTransaction",[h])))
