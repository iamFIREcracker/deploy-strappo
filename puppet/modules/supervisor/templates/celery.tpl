[program:<%= @appname %>]
command=<%= @celery %> worker --app=<%= @app %>
directory=<%= @wd %>
user=<%= @user %>
group=<%= @user %>
autostart=true
autorestart=true
redirect_stderr=True
