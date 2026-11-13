/**
 * @typedef {{type:string,id:Object,name?:string}} FDC3Context
 * @typedef {{id:string,type:'system'|'user',displayMetadata?:Object}} ChannelDescriptor
 * @typedef {{action:string,channelId?:string,context?:FDC3Context,contextType?:string,requestId?:string}} BrokerMessage
 * @typedef {{event:string,channelId?:string,context?:FDC3Context,channels?:ChannelDescriptor[],message?:string,requestId?:string}} BrokerEvent
 */
module.exports = {};
