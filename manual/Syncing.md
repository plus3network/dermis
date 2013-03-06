# Syncing

Collections and Models in dermis provide an easy way to sync data with the server via REST.

## Response

You can view a full listing of the response object's properties [on the superagent documentation page](http://visionmedia.github.com/superagent/#response-properties)

## Request Options

### type

Defaults to ```json``` but can also be ```form```,```xml```,```png```, etc.

Specifies the Content-Type

### headers

An object specifying the HTTP headers to send

### query

An object specifying the querystring parameters to send

### username

A string specifying the HTTP authentication username

### password

A string specifying the HTTP authentication password

### withCredentials

true or false to send cookies with cross-origin requests. Defaults to false.