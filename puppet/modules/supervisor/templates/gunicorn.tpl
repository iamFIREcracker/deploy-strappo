[program:<%= @appname %>]
command=<%= @gunicorn %> -c <%= @config %> <%= @use %>
directory=<%= @wd %>
user=<%= @user %>
group=<%= @user %>
autostart=true
autorestart=true
redirect_stderr=True
