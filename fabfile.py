#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

from fabric.api import env
from fabric.api import local
from fabric.api import require
from fabric.api import sudo
from fabric.colors import cyan
from fabric.decorators import task

from fabolous.fabolous import *


env.puppet_modulepath = 'puppet/modules'


@task
def vagrant():
    config = dict(line.split()
                  for line in local('vagrant ssh-config', capture=True)
                  .splitlines())
    env.user = config['User']
    env.hosts = [config['HostName']]
    env.port = config['Port']
    env.key_filename = config['IdentityFile']


@task
def dev():
    env.type = 'dev'

    env.user = 'app'
    env.hosts = ['178.62.103.185']


@task
def prod():
    env.type = 'prod'

    env.user = 'app'
    env.hosts = ['188.226.177.93']


@task
def www():
    env.appname = 'getstrappo'
    env.appport = '8001'
    env.repo_url = 'ssh://hg@bitbucket.org/iamFIREcracker/getstrappo'
    env.site_path = '/srv/www/%s' % env.appname
    env.venv_path = '/srv/www/%s/venv' % env.appname
    env.config = '%s_%s_config.py' % (env.appname, env.type)
    if env.type == 'dev':
        env.repo_branch = 'develop'
        env.servername = 'dev1.getstrappo.com'
    elif env.type == 'prod':
        env.repo_branch = 'production'
        env.servername = 'getstrappo.com'
    env.site_url = 'https://%s/en' % env.hosts[0]
    env.puppet_file = 'puppet/%s.pp' % env.appname
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
    env.appname = 'strappo-api'
    env.appport = '8000'
    env.repo_url = 'ssh://hg@bitbucket.org/iamFIREcracker/strappo-api'
    env.site_path = '/srv/www/%s' % env.appname
    env.venv_path = '/srv/www/%s/venv' % env.appname
    env.config = '%s_%s_config.py' % (env.appname, env.type)
    if env.type == 'dev':
        env.repo_branch = 'develop'
        env.servername = 'devapi1.getstrappo.com'
    elif env.type == 'prod':
        env.repo_branch = 'production'
        env.servername = 'api.getstrappo.com'
    env.site_url = 'https://%s/1/info' % env.hosts[0]
    env.puppet_file = 'puppet/%s.pp' % env.appname
    env.database_path = env.site_path + '/appdb.sqlite'
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
    env.appname = 'strappo-analytics'
    env.appport = '8002'
    env.repo_url = 'ssh://hg@bitbucket.org/iamFIREcracker/strappo-analytics'
    env.site_path = '/srv/www/%s' % env.appname
    env.venv_path = '/srv/www/%s/venv' % env.appname
    env.config = '%s_%s_config.py' % (env.appname, env.type)
    if env.type == 'dev':
        env.repo_branch = 'develop'
        env.servername = 'devanalytics1.getstrappo.com'
    elif env.type == 'prod':
        env.repo_branch = 'production'
        env.servername = 'analytics.getstrappo.com'
    env.site_url = 'https://%s/login' % env.hosts[0]
    env.puppet_file = 'puppet/%s.pp' % env.appname
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
