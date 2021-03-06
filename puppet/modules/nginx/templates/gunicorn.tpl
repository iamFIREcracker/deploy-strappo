server {
    server_name <%= @servername %>;

    location /static {
        alias <%= @staticfiles %>;
        expires 30d;
    }

    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;

        proxy_pass   http://<%= @proxypass %>;
    }
}
