# Error guide

## 404 and 500 default errors
When try to get a route, maybe it will returns a 404 error.
You can customize the error by writting a file named ``/app/404.html`` in your application.

It works with every errors (404, 500, ...)

**but actually, there is only 2 types of errors returned by the server. 404 and 500. Other are never raised**

## Parameters
You can also put some strings in your error files to personalize it's content.

### 404
- ``INJECT_REQ_PATH`` : replaced by the current URI
