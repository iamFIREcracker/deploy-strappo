#!/usr/bin/env python
# -*- coding: utf-8 -*-


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
def getstrappo():
    env.app = True
    env.appname = 'getstrappo'
    env.appport = '8001'
    env.repo_url = 'ssh://hg@bitbucket.org/iamFIREcracker/getstrappo'
    env.subdomain = 'www'
    env.check_url = '/en'
    env.puppet_file = 'puppet/getstrappo.pp'


@task
def api():
    env.app = True
    env.appname = 'strappo-api'
    env.appport = '8000'
    env.repo_url = 'ssh://hg@bitbucket.org/iamFIREcracker/strappo-api'
    env.subdomain = 'api'
    env.check_url = '/1/info'
    env.puppet_file = 'puppet/api.pp'


@task
def analytics():
    env.app = True
    env.appname = 'strappo-analytics'
    env.appport = '8002'
    env.repo_url = 'ssh://hg@bitbucket.org/iamFIREcracker/strappo-analytics'
    env.subdomain = 'analytics'
    env.check_url = '?limit=1'
    env.puppet_file = 'puppet/analytics.pp'


@task
def dev():
    require('app', provided_by=['getstrappo', 'api', 'analytics'])

    env.env_name = '%s-ny' % env.appname

    env.user = 'app'
    env.hosts = ['192.241.139.130']

    env.site_path = '/srv/www/%s' % env.appname
    env.venv_path = '/srv/www/%s/venv' % env.appname
    env.repo_branch = 'develop'

    env.database_path = env.site_path + '/appdb.sqlite'

    env.config = '%s_dev_config.py' % env.appname

    env.servername = '%s.dev.getstrappo.com' % env.subdomain
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

    env.config = '%s_prod_config.py' % env.appname

    env.servername = '%s.getstrappo.com' % env.subdomain
    env.site_url = 'http://%s%s' % (env.hosts[0], env.check_url)


@task
def bootstrap():
    ''' Configure the app '''
    print(cyan("Prerequisites..."))
    prerequisites()

    print(cyan("Cloning repo..."))
    rclone()

    print(cyan("Updating config..."))
    cupload()

    print(cyan("Applying puppet manifest..."))
    papply()

    print(cyan('Creating venv...'))
    vcreate()

    print(cyan('Initialize database...'))
    dbupdate()

    print(cyan('Recreate i18n strings...'))
    i18nupdate()

    restart()


@task
def update():
    ''' Update everything related to the app. '''
    print(cyan("Updating repo..."))
    rupdate()

    print(cyan("Updating config..."))
    cupload()

    print(cyan("Applying puppet manifest..."))
    papply()

    print(cyan('Updating venv...'))
    vupdate()

    print(cyan('Updating database...'))
    dbupdate()

    print(cyan('Recreate i18n strings...'))
    i18nupdate()

    restart()


@task
def restart():
    ''' Restart the app.  Usable from other commands or from the CLI.'''
    print(cyan("Restarting nginx..."))
    sdo("service nginx restart")

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
    print local(rsync_command, capture=False)
