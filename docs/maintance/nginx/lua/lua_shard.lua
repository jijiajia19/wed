local sharddata=ngx.shard.shard_data

local i=sharddata:get("i")
if not i then
  i=1
  sharddata:set("i",1)
  ngx.say("lazy set i ",i)
end

i = sharddata:incr("i", 1)
ngx.say("i=", i, "<br/>")