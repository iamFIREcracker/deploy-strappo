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

TITANIUM_KEY = 'v7uTBJ7mpeVyxYgoGm1l5zme6u8hAbGe'
TITANIUM_LOGIN = 'notifications'
TITANIUM_PASSWORD = 'notificationsisstrongenough'
TITANIUM_NOTIFICATION_CHANNEL = 'dev_channel'

EXPIRE_PASSENGERS_AFTER_MINUTES = 30

web.config.FACEBOOK_APP_SECRET = '01c93ff9c0fc2e76b6b85a0b64454581'
web.config.FACEBOOK_CACHE_EXPIRE_SECONDS = 60 * 60  # 1h

web.config.APP_MIN_VERSION_ANDROID = '1.12.0'
web.config.APP_MIN_VERSION_IOS = '1.12.0'
web.config.APP_MIN_VERSION = '1.12.0'
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
    },{
        'name': 'Massa',
            'center': {
                'lat': 44.037023,
                'lon': 10.140071
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
        'ends': dt.strptime('2020-03-29T02:00:00Z', '%Y-%m-%dT%H:%M:%SZ'),
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
    },
    {
        'name': 'Bar Eden',
        'info': 'poi_info_bar',
        'image': 'https://scontent-mxp1-1.xx.fbcdn.net/hphotos-xap1/v/t1.0-9/995049_766482446745617_2838624800228983681_n.jpg?oh=b6657d15b52e193028132493c28a4245&oe=55F13C04',
        'latitude': 43.866792,
        'longitude': 10.243564,
        'visible': True,
        'important_destination': True,
        'starts': dt.strptime('2015-03-18T15:00:00Z', '%Y-%m-%dT%H:%M:%SZ'),
        'ends': dt.strptime('2020-03-29T02:00:00Z', '%Y-%m-%dT%H:%M:%SZ'),
    }
]
