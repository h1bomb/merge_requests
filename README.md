# merge_requests

Merge requests base on openresty.

put this file into `/openresty/lualib/resty`

## useage:

nginx.conf
```
   location /mr {
     content_by_lua_block {
       local mr = require "resty.merge_requests"
       mr:send()
     }

   }

```
reload nginx,then you can use it.
