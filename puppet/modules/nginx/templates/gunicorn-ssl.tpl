upstream <%= @sitename %> {
    # server unix:/tmp/gunicorn.sock fail_timeout=0;
    # For a TCP configuration:
    server 127.0.0.1:<%= @appport %> fail_timeout=0;
}

server {
    listen 443 ssl;
    server_name <%= @servername %>;

    add_header Strict-Transport-Security "max-age=31536000; includeSubdomains";

    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 10s;

    ssl_certificate <%= @sslcert %>;
    ssl_certificate_key <%= @sslcertkey %>;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;
    ssl_prefer_server_ciphers on;
    keepalive_timeout 70;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    location /static/ {
        alias <%= @staticfiles %>;
        expires 30d;
    }

    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;

        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_pass   http://<%= @sitename %>;
    }
}
