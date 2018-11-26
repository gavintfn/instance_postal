

  web:
    host: XXXFQDNXXX
    protocol: https

  fast_server:
    enabled: false
    bind_address: 0.0.0.0
    port: 5010
    ssl_port: 5011

  general:
    use_ip_pools: false

  main_db:
    host: 127.0.0.1
    username: postal
    password:XXXMYSQL_ROOT_PASSWORDXXX
    database: postal

  message_db:
    host: 127.0.0.1
    username: postal
    password:XXXMYSQL_ROOT_PASSWORDXXX
    prefix: postal

  rabbitmq:
    host: 127.0.0.1
    username: postal
    password: XXXRABBITMQ_PASSWORDXXX
    vhost:/postal

  smtp_server:
    port: XXXSMTP_PORTXXX

  dns:
    mx_records:
      - mx.XXXHOSTNAMEXXX
    smtp_server_hostname: XXXFQNDXXX
    spf_include: spf.XXXFQNDXXX
    return_path: rp.XXXFQNDXXX
    route_domain: routes.XXXFQNDXXX
    track_domain: track.XXXFQNDXXX

  smtp:
    host: 127.0.0.1
    port: XXXSMTP_PORTXXX
    username:XXXADMIN_EMAILXXX
    password:XXXADMIN_PASSWORDXXX
    from_name: ADMIN
    from_address: XXXADMIN_EMAILXXX

  rails:
    environment: test
    XXXRAILS_SECRET_KEYXXX
