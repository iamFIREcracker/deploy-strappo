bind = "0.0.0.0:<%= @appport %>"
chdir = "<%= @workdir %>"
preload = True
reload = True
workers = 3
worker_class = 'sync'
timeout = 10
max_requests = 1200
loglevel = "INFO"
accesslog = '-'
errorlog = '-'
