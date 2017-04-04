# sinatra-webhooks-server
Simple sinatra script from testing webhooks and such

Used with ngrok to test signed and unsigned webhooks.

run this:

```
ngrok http 4567
```

followed by this:

```
ruby webhooks_server.rb
```