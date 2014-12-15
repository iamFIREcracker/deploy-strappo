server {
    listen 80;
    server_name <%= @servername %>;
    server_tokens off;

    return 301 https://$host$request_uri;
}
