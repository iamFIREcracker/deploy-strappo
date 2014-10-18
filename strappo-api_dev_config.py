#!/usr/bin/env python
# -*- coding: utf-8 -*-


import web

TITANIUM_KEY = 'kYnQ9GPVCYsCA27dBxb70yfv7wjZIQTQ'
TITANIUM_LOGIN = 'notifications'
TITANIUM_PASSWORD = 'notificationsisstrongenough'
TITANIUM_NOTIFICATION_CHANNEL = 'dev_channel'


web.config.LOG_SMTP_SERVER = 'smtp.mailgun.org'
web.config.LOG_SMTP_PORT = 587
web.config.LOG_SMTP_USERNAME = 'postmaster@sandbox564a36facd7d4e36b6f92109835f80fb.mailgun.org'
web.config.LOG_SMTP_PASSWORD = '1fbff3207b9ef57bdf6fe357c9fa7f92'
web.config.LOG_FROM = 'noreply@api.dev.getstrappo.com'
web.config.LOG_TO = ['matteo@matteolandi.net', 'bianchigiova@gmail.com']
web.config.LOG_SUBJECT = 'Internal Server Error on api.dev.getstrappo.com'
