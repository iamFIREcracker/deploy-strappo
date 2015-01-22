#!/usr/bin/env python
# -*- coding: utf-8 -*-


import web

web.config.REDIS_ADDRESS = '<%= @redisaddress %>'
web.config.REDIS_PORT = <%= @redisport %>

web.config.LOG_SMTP_SERVER = 'smtp.mailgun.org'
web.config.LOG_SMTP_PORT = 587
web.config.LOG_SMTP_USERNAME = 'postmaster@sandbox564a36facd7d4e36b6f92109835f80fb.mailgun.org'
web.config.LOG_SMTP_PASSWORD = '1fbff3207b9ef57bdf6fe357c9fa7f92'
web.config.LOG_FROM = 'noreply@api.dev.getstrappo.com'
web.config.LOG_TO = ['matteo@matteolandi.net', 'bianchigiova@gmail.com']
web.config.LOG_SUBJECT = 'Internal Server Error on api.dev.getstrappo.com'

DATABASE_URL = '<%= @databaseurl %>'

TITANIUM_KEY = 'kYnQ9GPVCYsCA27dBxb70yfv7wjZIQTQ'
TITANIUM_LOGIN = 'notifications'
TITANIUM_PASSWORD = 'notificationsisstrongenough'
TITANIUM_NOTIFICATION_CHANNEL = 'dev_channel'

web.config.APP_MIN_VERSION = '1.3.1'
web.config.APP_SERVED_REGIONS = [
    {
        'name': 'Viareggio',
        'center': {
            'lat': 43.873676,
            'lon': 10.248534
        },
        'radius': 10,
        'hours': [
            {
                'day_of_week': 0,
                'from': 0,
                'to': 24
            }, {
                'day_of_week': 1,
                'from': 0,
                'to': 24
            }, {
                'day_of_week': 2,
                'from': 0,
                'to': 24
            }, {
                'day_of_week': 3,
                'from': 0,
                'to': 24
            }, {
                'day_of_week': 4,
                'from': 0,
                'to': 24
            }, {
                'day_of_week': 5,
                'from': 0,
                'to': 24
            }, {
                'day_of_week': 6,
                'from': 0,
                'to': 24
            }
        ]
    }
]
