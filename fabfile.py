#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

from fabric.api import env
from fabric.api import local
from fabric.api import require
from fabric.api import sudo
from fabric.decorators import task

from fabolous.fabolous import check
from fabolous.fabolous import papply
from fabolous.fabolous import pcleanup
from fabolous.fabolous import pprepare
from fabolous.fabolous import ssh


env.puppet_modulepath = 'puppet/modules'


@task
def vagrant():
    env.type = 'vagrant'
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
def database():
    env.databasepath = '/srv/www/strappo-api/appdb.sqlite'
    env.puppet_file = 'puppet/database.pp'
    env.puppet_env = ' '.join([
        'FACTER_USER=%s' % env.user,
        'FACTER_DATABASEPATH=%s' % env.databasepath,
    ])
    env.check_command = 'ls %s' % env.databasepath


@task
def redis():
    env.redisaddress = '127.0.0.1'
    env.redisport = 6379
    env.puppet_file = 'puppet/redis.pp'
    env.puppet_env = ' '.join([
        'FACTER_REDISADDRESS=%s' % env.redisaddress,
        'FACTER_REDISPORT=%s' % env.redisport,
    ])
    env.check_command = 'pgrep redis'


@task
def nginx():
    env.sslcert = 'getstrappo.com.combined.crt'
    env.sslcertkey = 'getstrappo.com.key'
    if env.type in ['vagrant', 'dev']:
        env.getstrappoit_servername = 'dev1.getstrappo.it'
        env.getstrappo_servername = 'dev1.getstrappo.com'
        env.api_servername = 'devapi1.getstrappo.com'
        env.analytics_servername = 'devanalytics1.getstrappo.com'
    elif env.type == 'prod':
        env.getstrappoit_servername = 'getstrappo.it'
        env.getstrappo_servername = 'getstrappo.com'
        env.api_servername = 'api.getstrappo.com'
        env.analytics_servername = 'analytics.getstrappo.com'
    env.getstrappo_appport = '8001'
    env.getstrappo_staticfiles = '/srv/www/getstrappo/static'
    env.api_appport = '8000'
    env.api_staticfiles = '/srv/www/strappo-api/static'
    env.analytics_appport = '8002'
    env.analytics_staticfiles = '/srv/www/strappo-analytics/static'
    env.puppet_file = 'puppet/nginx.pp'
    env.puppet_env = ' '.join([
        'FACTER_USER=%s' % env.user,
        'FACTER_SSLCERT=%s' % env.sslcert,
        'FACTER_SSLCERTKEY=%s' % env.sslcertkey,
        'FACTER_GETSTRAPPOIT_SERVERNAME=%s' % env.getstrappoit_servername,
        'FACTER_GETSTRAPPO_SERVERNAME=%s' % env.getstrappo_servername,
        'FACTER_GETSTRAPPO_APPPORT=%s' % env.getstrappo_appport,
        'FACTER_GETSTRAPPO_STATICFILES=%s' % env.getstrappo_staticfiles,
        'FACTER_API_SERVERNAME=%s' % env.api_servername,
        'FACTER_API_APPPORT=%s' % env.api_appport,
        'FACTER_API_STATICFILES=%s' % env.api_staticfiles,
        'FACTER_ANALYTICS_SERVERNAME=%s' % env.analytics_servername,
        'FACTER_ANALYTICS_APPPORT=%s' % env.analytics_appport,
        'FACTER_ANALYTICS_STATICFILES=%s' % env.analytics_staticfiles,
    ])
    env.check_command = 'pgrep nginx'


@task
def getstrappoit():
    if env.type in ['vagrant', 'dev']:
        env.servername = 'dev1.getstrappo.it'
    elif env.type == 'prod':
        env.servername = 'getstrappo.it'
    env.puppet_file = 'puppet/getstrappoit.pp'
    env.puppet_env = ' '.join([
    ])
    env.check_command = ('curl --silent --insecure -I -H "Host: %s" "%s"'
                         ' | grep getstrappo.com' %
                         (env.servername, 'http://%s' % env.hosts[0]))


@task
def getstrappo():
    env.workdir = '/srv/www/getstrappo'
    env.venvdir = '/srv/www/getstrappo/venv'
    env.appname = 'getstrappo'
    env.appport = '8001'
    env.repo_url = 'ssh://hg@bitbucket.org/iamFIREcracker/getstrappo'
    if env.type in ['vagrant', 'dev']:
        env.repo_branch = 'develop'
        env.localconfig = 'getstrappo_dev_local_config.py.tpl'
        env.gunicornconf = 'strappo-analytics_dev_gunicorn.conf.py.tpl'
        env.servername = 'dev1.getstrappo.com'
    elif env.type == 'prod':
        env.repo_branch = 'production'
        env.localconfig = 'getstrappo_prod_local_config.py.tpl'
        env.gunicornconf = 'strappo-analytics_prod_gunicorn.conf.py.tpl'
        env.servername = 'getstrappo.com'
    env.puppet_file = 'puppet/getstrappo.pp'
    env.puppet_env = ' '.join([
        'FACTER_WORKDIR=%s' % env.workdir,
        'FACTER_VENVDIR=%s' % env.venvdir,
        'FACTER_APPNAME=%s' % env.appname,
        'FACTER_APPPORT=%s' % env.appport,
        'FACTER_USER=%s' % env.user,
        'FACTER_REPO_URL=%s' % env.repo_url,
        'FACTER_REPO_BRANCH=%s' % env.repo_branch,
        'FACTER_LOCALCONFIG=%s' % env.localconfig,
        'FACTER_GUNICORNCONF=%s' % env.gunicornconf,
    ])
    env.check_command = ('curl --silent --insecure -I -H "Host: %s" "%s"'
                         ' | grep "200 OK"' %
                         (env.servername, 'https://%s/en' % env.hosts[0]))


@task
def api():
    env.workdir = '/srv/www/strappo-api'
    env.venvdir = '/srv/www/strappo-api/venv'
    env.appname = 'strappo-api'
    env.appport = '8000'
    env.repo_url = 'ssh://hg@bitbucket.org/iamFIREcracker/strappo-api'
    if env.type in ['vagrant', 'dev']:
        env.repo_branch = 'develop'
        env.localconfig = 'strappo-api_dev_local_config.py.tpl'
        env.localceleryconfig = 'strappo-api_dev_local_celeryconfig.py.tpl'
        env.gunicornconf = 'strappo-api_dev_gunicorn.conf.py.tpl'
        env.servername = 'devapi1.getstrappo.com'
    elif env.type == 'prod':
        env.repo_branch = 'production'
        env.localconfig = 'strappo-api_prod_local_config.py.tpl'
        env.localceleryconfig = 'strappo-api_prod_local_celeryconfig.py.tpl'
        env.gunicornconf = 'strappo-api_prod_gunicorn.conf.py.tpl'
        env.servername = 'api.getstrappo.com'
    env.databaseurl = 'sqlite:////srv/www/strappo-api/appdb.sqlite'
    env.redisaddress = '127.0.0.1'
    env.redisport = 6379
    env.celerybrokerurl = 'redis://127.0.0.1:6379/0'
    env.celeryresultbackend = 'redis://127.0.0.1:6379/0'
    env.puppet_file = 'puppet/strappo-api.pp'
    env.puppet_env = ' '.join([
        'FACTER_WORKDIR=%s' % env.workdir,
        'FACTER_VENVDIR=%s' % env.venvdir,
        'FACTER_APPNAME=%s' % env.appname,
        'FACTER_APPPORT=%s' % env.appport,
        'FACTER_USER=%s' % env.user,
        'FACTER_REPO_URL=%s' % env.repo_url,
        'FACTER_REPO_BRANCH=%s' % env.repo_branch,
        'FACTER_LOCALCONFIG=%s' % env.localconfig,
        'FACTER_DATABASEURL=%s' % env.databaseurl,
        'FACTER_REDISADDRESS=%s' % env.redisaddress,
        'FACTER_REDISPORT=%s' % env.redisport,
        'FACTER_LOCALCELERYCONFIG=%s' % env.localceleryconfig,
        'FACTER_CELERYBROKERURL=%s' % env.celerybrokerurl,
        'FACTER_CELERYRESULTBACKEND=%s' % env.celeryresultbackend,
        'FACTER_GUNICORNCONF=%s' % env.gunicornconf,
    ])
    env.check_command = ('curl --silent --insecure -I -H "Host: %s" "%s"'
                         ' | grep "200 OK"' %
                         (env.servername, 'https://%s/1/info' % env.hosts[0]))


@task
def analytics():
    env.workdir = '/srv/www/strappo-analytics'
    env.venvdir = '/srv/www/strappo-analytics/venv'
    env.appname = 'strappo-analytics'
    env.appport = '8002'
    env.repo_url = 'ssh://hg@bitbucket.org/iamFIREcracker/strappo-analytics'
    if env.type in ['vagrant', 'dev']:
        env.repo_branch = 'develop'
        env.localconfig = 'strappo-analytics_dev_local_config.py.tpl'
        env.gunicornconf = 'strappo-analytics_dev_gunicorn.conf.py.tpl'
        env.servername = 'devanalytics1.getstrappo.com'
    elif env.type == 'prod':
        env.repo_branch = 'production'
        env.localconfig = 'strappo-analytics_prod_local_config.py.tpl'
        env.gunicornconf = 'strappo-analytics_prod_gunicorn.conf.py.tpl'
        env.servername = 'analytics.getstrappo.com'
    env.databaseurl = 'sqlite:////srv/www/strappo-api/appdb.sqlite'
    env.puppet_file = 'puppet/strappo-analytics.pp'
    env.puppet_env = ' '.join([
        'FACTER_WORKDIR=%s' % env.workdir,
        'FACTER_VENVDIR=%s' % env.venvdir,
        'FACTER_APPNAME=%s' % env.appname,
        'FACTER_APPPORT=%s' % env.appport,
        'FACTER_USER=%s' % env.user,
        'FACTER_REPO_URL=%s' % env.repo_url,
        'FACTER_REPO_BRANCH=%s' % env.repo_branch,
        'FACTER_LOCALCONFIG=%s' % env.localconfig,
        'FACTER_DATABASEURL=%s' % env.databaseurl,
        'FACTER_GUNICORNCONF=%s' % env.gunicornconf,
    ])
    env.check_command = ('curl --silent --insecure -I -H "Host: %s" "%s"'
                         ' | grep "200 OK"' %
                         (env.servername, 'https://%s/login' % env.hosts[0]))


@task
def bootstrap():
    for c in [database, redis, nginx]:
        c()
        papply()

    for c in [getstrappo, api, analytics]:
        c()
        papply()

    for c in [getstrappo, api, analytics]:
        c()
        check()


@task
def update():
    try:
        pprepare()
        papply()
    finally:
        pcleanup()


@task
def updateall():
    try:
        pprepare()
        for c in [getstrappoit, getstrappo, api, analytics]:
            c()
            papply()
    finally:
        pcleanup()


@task
def checkall():
    for c in [getstrappoit, getstrappo, api, analytics]:
        c()
        check()


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
