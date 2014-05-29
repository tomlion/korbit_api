korbit_api
==========

**WARNING: THIS GEM IS IN ACTIVE DEVELOPMENT.  Please wait till the first alpha release if you unless like things changing on you by the day.**

---

A ruby wrapper around the Korbit API.

```
client = KorbitAPI::Client.new access_token: '<ACCESS_TOKEN>'
user = client.user

# User Info
user.info

# Buy BTC
user.orders.buy(type: 'limit', price: 1000, coin_amount: 1)

# Cancel an order
user.orders.cancel(id: 5400)
# alternatively
open_orders = user.orders.open
open_orders.first.cancel
```

Currently Supports:
* user.info
* user.wallet
* user.coins.address.assign
* user.coins.out
* user.coins.out.cancel
* user.coins.status
* user.orders.open
* user.orders.buy
* user.orders.sell
* user.orders.cancel
