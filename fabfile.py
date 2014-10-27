#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import sys

from fabric.api import hide
from fabric.api import cd
from fabric.api import env
from fabric.api import local
from fabric.api import put
from fabric.api import run
from fabric.api import require
from fabric.api import settings
from fabric.api import sudo
from fabric.colors import cyan
from fabric.colors import green
from fabric.colors import red
from fabric.decorators import task

from fabolous.fabolous import *


env.puppet_modulepath = 'puppet/modules'


@task
def www():
    env.app = True
    env.appname = 'getstrappo'
    env.appport = '8001'
    env.repo_url = 'ssh://hg@bitbucket.org/iamFIREcracker/getstrappo'
    env.check_url = '/en'
    env.puppet_file = 'puppet/getstrappo.pp'
    env.bootstrap_steps = [
        (cyan('Prerequisites...'), prerequisites),
        (cyan('Cloning repo...'), rclone),
        (cyan('Uploading config...'), cupload),
        (cyan('Applying puppet manifest...'), papply),
        (cyan('Creating venv...'), vcreate),
        (cyan('Recreate i18n strings...'), i18nupdate),
        (cyan('Restart...'), restart)
    ]
    env.update_steps = [
        (cyan('Updating repo...'), rupdate),
        (cyan('Uploading config...'), cupload),
        (cyan('Applying puppet manifest...'), papply),
        (cyan('Updating venv...'), vupdate),
        (cyan('Recreate i18n strings...'), i18nupdate),
        (cyan('Restart...'), restart)
    ]


@task
def api():
    env.app = True
    env.appname = 'strappo-api'
    env.appport = '8000'
    env.repo_url = 'ssh://hg@bitbucket.org/iamFIREcracker/strappo-api'
    env.subdomain = 'api'
    env.check_url = '/1/info'
    env.puppet_file = 'puppet/api.pp'
    env.bootstrap_steps = [
        (cyan('Prerequisites...'), prerequisites),
        (cyan('Cloning repo...'), rclone),
        (cyan('Uploading config...'), cupload),
        (cyan('Applying puppet manifest...'), papply),
        (cyan('Creating venv...'), vcreate),
        (cyan('Initialize database...'), dbupdate),
        (cyan('Recreate i18n strings...'), i18nupdate),
        (cyan('Restart...'), restart)
    ]
    env.update_steps = [
        (cyan('Updating repo...'), rupdate),
        (cyan('Uploading config...'), cupload),
        (cyan('Applying puppet manifest...'), papply),
        (cyan('Updating venv...'), vupdate),
        (cyan('Updating database...'), dbupdate),
        (cyan('Recreate i18n strings...'), i18nupdate),
        (cyan('Restart...'), restart)
    ]


@task
def analytics():
    env.app = True
    env.appname = 'strappo-analytics'
    env.appport = '8002'
    env.repo_url = 'ssh://hg@bitbucket.org/iamFIREcracker/strappo-analytics'
    env.subdomain = 'analytics'
    env.check_url = '/login'
    env.puppet_file = 'puppet/analytics.pp'
    env.bootstrap_steps = [
        (cyan('Prerequisites...'), prerequisites),
        (cyan('Cloning repo...'), rclone),
        (cyan('Uploading config...'), cupload),
        (cyan('Applying puppet manifest...'), papply),
        (cyan('Creating venv...'), vcreate),
        (cyan('Restart...'), restart)
    ]
    env.update_steps = [
        (cyan('Updating repo...'), rupdate),
        (cyan('Uploading config...'), cupload),
        (cyan('Applying puppet manifest...'), papply),
        (cyan('Updating venv...'), vupdate),
        (cyan('Restart...'), restart)
    ]


@task
def dev():
    require('app', provided_by=['getstrappo', 'api', 'analytics'])

    env.env_name = '%s-ny' % env.appname

    env.user = 'app'
    env.hosts = ['178.62.103.185']

    env.site_path = '/srv/www/%s' % env.appname
    env.venv_path = '/srv/www/%s/venv' % env.appname
    env.repo_branch = 'develop'

    env.database_path = env.site_path + '/appdb.sqlite'

    env.config = '%s_dev_config.py' % env.appname

    env.servername = 'dev.getstrappo.com'
    if 'subdomain' in env:
        env.servername = '%s.%s' % (env.subdomain, env.servername)
    env.site_url = 'http://%s%s' % (env.hosts[0], env.check_url)


@task
def prod():
    require('app', provided_by=['getstrappo', 'api', 'analytics'])

    env.env_name = '%s-am' % env.appname

    env.user = 'app'
    env.hosts = ['188.226.177.93']

    env.site_path = '/srv/www/%s' % env.appname
    env.venv_path = '/srv/www/%s/venv' % env.appname
    env.repo_branch = 'production'

    env.database_path = env.site_path + '/appdb.sqlite'

    env.config = '%s_prod_config.py' % env.appname

    env.servername = 'getstrappo.com'
    if 'subdomain' in env:
        env.servername = '%s.%s' % (env.subdomain, env.servername)
    env.site_url = 'http://%s%s' % (env.hosts[0], env.check_url)


@task
def bootstrap():
    require('bootstrap_steps')

    for (msg, step) in env.bootstrap_steps:
        print(msg)
        step()


@task
def update():
    require('update_steps')

    for (msg, step) in env.update_steps:
        print(msg)
        step()


@task
def restart():
    ''' Restart the app.  Usable from other commands or from the CLI.'''
    print(cyan("Restarting supervisor..."))
    # XXX Issuing a 'service supervisor restart' will produce an error!!!
    sdo("service supervisor stop && sleep 5 && service supervisor start")


@task
def pull_database():
    '''Copy the uploads from the site to your local machine.'''
    require('database_path')

    sudo('chmod -R a+r "%s"' % env.database_path)

    rsync_command = r"""rsync -av -e 'ssh -p %s' %s@%s:%s %s""" % (
        env.port,
        env.user, env.host,
        env.database_path,
        '.'
    )
    local(rsync_command, capture=False)
