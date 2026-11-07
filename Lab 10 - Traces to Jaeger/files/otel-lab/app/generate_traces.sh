#!/bin/bash

echo "Generating traces for Jaeger demonstration..."

# Function to make random requests
make_requests() {
    local count=$1
    for i in $(seq 1 $count); do
        # Random endpoint selection
        case $((RANDOM % 4)) in
            0)
                curl -s http://localhost:5000/ > /dev/null
                echo "Made request to home endpoint"
                ;;
            1)
                user_id=$((RANDOM % 10 + 1))
                curl -s http://localhost:5000/api/users/$user_id > /dev/null
                echo "Made request to user endpoint (ID: $user_id)"
                ;;
            2)
                curl -s http://localhost:5000/api/slow > /dev/null
                echo "Made request to slow endpoint"
                ;;
            3)
                curl -s http://localhost:5000/nonexistent > /dev/null
                echo "Made request to non-existent endpoint (404)"
                ;;
        esac

        # Random sleep between requests
        sleep $(echo "scale=2; $RANDOM/32767 * 2" | bc -l)
    done
}

# Generate traces
make_requests 20

echo "Trace generation completed!"
