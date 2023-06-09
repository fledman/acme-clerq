## ACME for Clerq

There are two options for running the code: Docker or Local Ruby.

### Docker
Build the docker image:
```
docker build -t acme .
```
Then, run the server:
```
docker run --rm -it -p 5000:5000 acme
```

### Local Ruby
1. Install Ruby version 3.2.1 locally.
2. Fetch the gems via bundler: `bundle install`
3. Start the server: `bin/start.sh`

### Using the server
The main endpoint is `POST /api/settle`. It expects a JSON payload in the body containing two parameters:
 * `merchant` aka the `name` or `id` of a known merchant in ACME
 * `date` the date to compute settlement in yyyy-mm-dd format (cannot be a weekend)

As an example, using curl:
```
curl -v -k -X POST -d '{"merchant":"Weeks Group LLC","date":"2022-12-19"}' -H 'Content-Type: application/json' 'http://0.0.0.0:5000/api/settle' | jq '.'
```
will produce a response that looks like:
 ```json
 {
  "amount": 1826.51,
  "transaction_count": 4,
  "transactions": [
    "2391f979-e3cb-4443-a878-76484d2f057b",
    "475febd0-b7b0-4cd7-9a32-c043171e6b48",
    "87a37fba-7b69-4bdd-9a49-c8630bbaf503",
    "398c989f-220c-46f9-a09e-e384dc67ba17"
  ],
  "merchant": {
    "id": "5397f5db-13bb-4d31-a6d5-f745d1de40a6",
    "name": "Weeks Group LLC"
  },
  "window": {
    "created_at__gt": "2022-12-16T17:00:00Z",
    "created_at__lte": "2022-12-19T17:00:00Z"
  }
}
 ```

### Unreliability
Due to the intermittent failures of the ACME server, there is basic retry functionality baked into the request handling.

### Code Layout
[lib/acme/models](lib/acme/models) contains data classes for Consumer, Merchant, Order, and Transaction.

[lib/acme/connect.rb](lib/acme/connect.rb) handles actual http requests and retry behavior.

[lib/acme/lookup.rb](lib/acme/lookup.rb) handles pagination and binds response data into models.

[lib/acme/settlement.rb](lib/acme/settlement.rb) performs the settlement computations.

[app/api_application.rb](app/api_application.rb) contains the REST API definition.

### Convenience
An endpoint for listing all available merchants is available via `GET /api/merchants`

A Ruby REPL with the code loaded can be launched in terminal via `bin/console`


