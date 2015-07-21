cups:
  # Here is how to hold all print jobs: lpadmin -p PrinterName -o job-hold-until-default=indefinite
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: cups
    - watch:
      - file: /etc/cups/printers.conf
      - file: /etc/cups/cupsd.conf

/etc/cups/cupsd.conf:
  file.managed:
    - source: salt://conf/cups/cupsd.conf
    - user: root
    - group: root
    - mode: 644

/etc/cups/printers.conf:
  file.managed:
    - source: salt://conf/cups/printers.conf
    - user: root
    - group: lp
    - mode: 600

catchallPrinter:
  cmd.run:
    - name: lpadmin -p Catchall -o job-hold-until-default=indefinite
    - require:
      - service: cups
      - file: /etc/cups/cupsd.conf
      - file: /etc/cups/printers.conf

php5:
  pkg:
    - installed

php5-pgsql:
  pkg:
    - installed

curl:
  pkg:
    - installed

php-apc:
  pkg:
    - installed

php5-ldap:
  pkg:
    - installed

php5-intl:
  pkg:
    - installed

postgresql-9.1:
  pkg:
    - installed

postgresql-client-9.1:
  pkg:
    - installed

git:
  pkg:
    - installed


/etc/ldap/ldap.conf:
  file.managed:
    - source: salt://conf/ldap/ldap.conf
    - require:
      - pkg: php5-ldap

cvs:
  pkg:
    - installed

apache2:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: apache2
      - pkg: php5
    - watch:
      - pkg: apache2
      - pkg: php5
      - pkg: php5-pgsql
      - pkg: php-apc
      - pkg: php5-ldap
      - cmd: a2enmod rewrite
      - cmd: a2enmod ssl
      - file: apache-default

get-composer:
  cmd.run:
    - name: 'CURL=`which curl`; $CURL -sS https://getcomposer.org/installer | php'
    - unless: test -f /usr/local/bin/composer
    - cwd: /root/
    - require:
      - pkg: curl

install-composer:
  cmd.wait:
    - name: mv /root/composer.phar /usr/local/bin/composer
    - cwd: /root/
    - watch:
      - cmd: get-composer

cups.git:
  git.latest:
    - name: https://github.com/emisaacson/SecurePrint-Server.git
    - rev: master
    - target: /var/www/cups
    - force: True
    - require:
      - pkg: git
      - file: /var/www/cups

/var/www/cups:
  file.directory:
    - user: root
    - group: www-data
    - makedirs: True
    - recurse:
      - user
      - group
  composer.installed:
    - no_dev: true
    - require:
      - cmd: install-composer
      - git: cups.git

/var/www/cups/config.yaml:
  file.managed:
    - source: salt://conf/app/config.yaml
    - user: root
    - group: www-data
    - mode: 644
    - template: jinja
    - require:
      - git: cups.git
      - file: /var/www/cups
    - defaults:
        dbhost: {{ pillar['dbhost'] }}
        dbname: {{ pillar['dbname'] }}
        dbuser: {{ pillar['dbuser'] }}
        dbpassword: {{ pillar['dbpassword'] }}
        cupshost: {{ pillar['cupshost'] }}


phpipp:
  cmd.run:
    - name: 'cvs -z3 -d:pserver:anonymous@cvs.savannah.nongnu.org:/sources/phpprintipp co phpprintipp'
    - cwd: /var/www/cups/vendor/
    - require:
      - composer: /var/www/cups

apache-default:
  file.managed:
    - name: /etc/apache2/sites-available/default
    - source: salt://conf/apache/default
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: apache2
      - git: cups.git

a2enmod ssl:
  cmd:
    - run
    - unless: test -f /etc/apache2/mods-enabled/ssl.load
    - require:
      - pkg: apache2

a2enmod rewrite:
  cmd:
    - run
    - unless: test -f /etc/apache2/mods-enabled/rewrite.load
    - require:
      - pkg: apache2

pg_hba.conf:
  file.managed:
    - name: /etc/postgresql/9.1/main/pg_hba.conf
    - source: salt://conf/postgres/pg_hba.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: postgresql-9.1
    - defaults:
        database: {{ pillar['dbname'] }}
        dbuser: {{ pillar['dbuser'] }}
        address: {{ pillar['dblistenaddress'] }}

postgresql:
  service:
    - running
    - enable: True
    - watch:
      - pkg: postgresql-9.1
      - file: pg_hba.conf

dbuser:
  postgres_user.present:
    - name: {{ pillar['dbuser'] }}
    - login: True
    - password: {{ pillar['dbpassword'] }}
    - require:
      - service: postgresql
dbname:
  postgres_database.present:
    - name: {{ pillar['dbname'] }}
    - owner: {{ pillar['dbuser'] }}
    - require:
      - postgres_user: dbuser

schema:
  file.managed:
    - name: /tmp/schema
    - source: salt://conf/postgres/schema
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cat /tmp/schema | psql -d {{ pillar['dbname'] }} && touch /tmp/schema_imported
    - creates: /tmp/schema_imported
    - user: postgres
    - require:
      - file: schema
      - postgres_database: dbname

sqlpermissions:
  cmd.run:
    - name: psql -d {{ pillar['dbname'] }} -c "grant select, update, delete, insert on all tables in schema public to {{ pillar['dbuser'] }}; grant usage on all sequences in schema public to {{ pillar['dbuser'] }};" && touch /tmp/permissions_set
    - creates: /tmp/permissions_set
    - user: postgres
    - require:
      - cmd: schema