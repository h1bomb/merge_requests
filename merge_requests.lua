-- merge requests
local _M = {
  _VERSION = '0.01',
}

local NO_REQ = "no requests!"

function sendMsg(code,Msg)
  ngx.status = code
  ngx.say('{ "code":',code,',"message":',Msg,'}')
end

-- send requests
function _M.send()
  local cjson = require "cjson"

  local reqs = {}
  ngx.req.read_body()
  local args = ngx.req.get_body_data()
  
  if args == nil or args == '' then
    sendMsg(500,NO_REQ)
    return
  end

  local argsObject = cjson.decode(args)
  for key,val in pairs(argsObject) do
    table.insert(reqs,{val["path"],{args = val["args"]}})
  end

  if table.getn(reqs) == 0 then
    sendMsg(500,NO_REQ)
    return
  end

  local resps = { ngx.location.capture_multi(reqs) }

  local allbody = {}
  for i, resp in ipairs(resps) do
    if resp.status == ngx.HTTP_OK then
      table.insert(allbody,resp.body)
    else
      table.insert(allbody,"{}")
    end

  end
  local allRet = table.concat(allbody,",")
  ngx.status = 200
  ngx.header["Content-Type"] = "application/json"
  ngx.say("[",allRet,"]")
end

return _M
