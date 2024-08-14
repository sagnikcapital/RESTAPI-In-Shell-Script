#!/bin/bash
echo "Server Start at: http://127.0.0.1:8080"
while true
do
    # Listen for incoming requests on port 8080
    REQUEST=$(nc -l -p 8080)
    
    # Extract the HTTP method
    METHOD=$(echo "$REQUEST" | grep -oE '^[A-Z]+')
    
    # Extract the request path
    PATH=$(echo "$REQUEST" | grep -oE ' /[^ ]+' | cut -d' ' -f2)
    echo $PATH;
    # If the request is a POST to /login
    if [[ "$METHOD" == "POST" && "$PATH" == "/login" ]]; then
        # Extract the body of the request (assuming the body starts after a blank line)
        BODY=$(echo "$REQUEST" | awk 'NR>1 { print }' | tr -d '\r')
        
        # Extract phone number and OTP from the JSON body
        PHONE=$(echo "$BODY" | jq -r '.phone')
        OTP=$(echo "$BODY" | jq -r '.otp')
        
        # Check if phone number and OTP are provided (simple validation)
        if [[ -z "$PHONE" || -z "$OTP" ]]; then
            RESPONSE="HTTP/1.1 400 Bad Request\r\nContent-Type: application/json\r\n\r\n{\"error\": \"Phone number and OTP are required\"}"
        else
            # Dummy validation: let's assume any OTP "1234" is valid for this example
            if [[ "$OTP" == "1234" ]]; then
                RESPONSE="HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n{\"message\": \"Login successful\", \"phone\": \"$PHONE\"}"
            else
                RESPONSE="HTTP/1.1 401 Unauthorized\r\nContent-Type: application/json\r\n\r\n{\"error\": \"Invalid OTP\"}"
            fi
        fi
    else
        RESPONSE="HTTP/1.1 404 Not Found\r\n\r\n"
    fi

    # Send the response back to the client
    echo -e "$RESPONSE" | nc -l -p 8080
done
