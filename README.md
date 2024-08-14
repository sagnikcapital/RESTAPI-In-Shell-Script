# (Mobile Server Logged in) REST API In Shell Script
### Setup
```sh
$ git clone https://github.com/sagnikcapital/RESTAPI-In-Shell-Script.git
```
```sh
$ chmod +x login.sh
```

### Usage
```sh
$ ./login.sh
```

### POST Login
```sh
curl -X POST http://127.0.0.1:8080/login \
>      -H "Content-Type: application/json" \
>      -d '{"phone": "1234567890", "otp": "1234"}'
```

### Response
```json
{
    "message": "Login successful",
    "phone": "1234567890",
    "_token": "shyrjdndknsk78ndhyd87nsdmnskjdksjkkjdnkk:dksuj8njjdh"
}
```