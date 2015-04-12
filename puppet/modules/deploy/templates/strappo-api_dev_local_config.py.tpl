#!/usr/bin/env python
# -*- coding: utf-8 -*-

from datetime import datetime as dt

import web

web.config.REDIS_ADDRESS = '<%= @redisaddress %>'
web.config.REDIS_PORT = <%= @redisport %>

web.config.LOG_SMTP_SERVER = 'smtp.mailgun.org'
web.config.LOG_SMTP_PORT = 587
web.config.LOG_SMTP_USERNAME = 'postmaster@sandbox564a36facd7d4e36b6f92109835f80fb.mailgun.org'
web.config.LOG_SMTP_PASSWORD = '1fbff3207b9ef57bdf6fe357c9fa7f92'
web.config.LOG_FROM = 'noreply@api.dev.getstrappo.com'
web.config.LOG_TO = ['matteo@matteolandi.net']
web.config.LOG_SUBJECT = 'Internal Server Error on api.dev.getstrappo.com'

DATABASE_URL = '<%= @databaseurl %>'

TITANIUM_KEY = 'FYPIAZrgsdb7cNIbb2EYBLgLgYM7C7oG'
TITANIUM_LOGIN = 'notifications'
TITANIUM_PASSWORD = 'notificationsisstrongenough'
TITANIUM_NOTIFICATION_CHANNEL = 'dev_channel'

EXPIRE_PASSENGERS_AFTER_MINUTES = 30

web.config.FACEBOOK_APP_SECRET = 'b68c00bc269042577917fa95ec97e7c4'

web.config.APP_MIN_VERSION = '1.7.0'
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
web.config.APP_POIS = [
    {
        'name': 'Strappo HQ',
        'info': 'poi_info_location',
        'image': 'https://fbcdn-sphotos-a-a.akamaihd.net/hphotos-ak-xpf1/v/t1.0-9/10796_984715708212110_8041308266048094515_n.png?oh=2d1de9e3d924f0ce815ea078092250c8&oe=557968E5&__gda__=1434070286_39fba896c19edd5cecf76be35e30bf7e',
        'latitude': 43.8679166,
        'longitude': 10.24869382,
        'visible': True,
        'important_destination': True,
        'starts': dt.strptime('2015-03-18T15:00:00Z', '%Y-%m-%dT%H:%M:%SZ'),
        'ends': dt.strptime('2015-03-29T02:00:00Z', '%Y-%m-%dT%H:%M:%SZ'),
    },
    {
        'name': 'EGG, bitch!',
        'info': 'poi_info_event',
        'image': 'https://fbcdn-sphotos-a-a.akamaihd.net/hphotos-ak-xap1/v/t1.0-9/31605_374262762664769_333154806_n.jpg?oh=3635c549291ada4821c529224bf702a7&oe=5581570F&__gda__=1433745149_98e0021f423664f4ced730967384f1b3',
        'latitude': 43.889217,
        'longitude': 10.228662,
        'visible': True,
        'important_destination': True,
        'starts': dt.strptime('2015-03-18T15:00:00Z', '%Y-%m-%dT%H:%M:%SZ'),
        'ends': dt.strptime('2015-03-29T02:00:00Z', '%Y-%m-%dT%H:%M:%SZ'),
    }
]
