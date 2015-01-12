CELERYD_CONCURRENCY = 1

BROKER_URL = '<%= @celerybrokerurl %>'
CELERY_RESULT_BACKEND = '<%= @celeryresultbackend %>'

CELERY_SEND_TASK_ERROR_EMAILS = True
ADMINS = (
    ('Matteo Landi', 'matteo@matteolandi.net'),
    ('Giovanni Bianchi', 'bianchigiova@gmail.com'),
)
SERVER_EMAIL = 'noreply@api.dev.getstrappo.com'
EMAIL_HOST = 'smtp.mailgun.org'
EMAIL_PORT = 587
EMAIL_HOST_USER = 'postmaster@sandbox564a36facd7d4e36b6f92109835f80fb.mailgun.org'
EMAIL_HOST_PASSWORD = '1fbff3207b9ef57bdf6fe357c9fa7f92'
