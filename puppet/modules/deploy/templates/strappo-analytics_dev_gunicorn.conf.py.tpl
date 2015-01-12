bind = "0.0.0.0:<%= @appport %>"
chdir = "<%= @workdir %>"
preload = True
reload = True
workers = 2
worker_class = 'gevent'
timeout = 10
max_requests = 1200
loglevel = "INFO"
accesslog = '-'
errorlog = '-'
