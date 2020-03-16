#!/bin/bash

if [ ! -z ${SMTP_LOGIN+x} ] && [ ! -z ${SMTP_PASSWORD+x} ] && [ "$SMTP_LOGIN" != "" ] && [ "$SMTP_PASSWORD" != "" ]; then
	echo "env SMTP_LOGIN: sendgrid credentials for email routing";
	echo "[smtp.sendgrid.net]:2525 ${SMTP_LOGIN}:${SMTP_PASSWORD}" > /etc/postfix/sasl_passwd

	postmap /etc/postfix/sasl_passwd
	chmod 600 /etc/postfix/sasl_passwd.db
	rm /etc/postfix/sasl_passwd

	### update email relay configuration for SendGrid
	sed -i 's/default_transport = error//g' /etc/postfix/main.cf
    sed -i 's/relay_transport = error//g'   /etc/postfix/main.cf

    ### delete following lines if already exist before adding
    sed -i '/relayhost/d'                   /etc/postfix/main.cf
    sed -i '/smtp_tls_security_level/d'     /etc/postfix/main.cf
    sed -i '/smtp_sasl_auth_enable/d'       /etc/postfix/main.cf
    sed -i '/smtp_sasl_password_maps/d'     /etc/postfix/main.cf
    sed -i '/header_size_limit/d'           /etc/postfix/main.cf
    sed -i '/smtp_sasl_security_options/d'  /etc/postfix/main.cf

    ### add following lines
    echo "relayhost = [smtp.sendgrid.net]:2525"                    >> /etc/postfix/main.cf
    echo "smtp_tls_security_level = encrypt"                       >> /etc/postfix/main.cf
    echo "smtp_sasl_auth_enable = yes"                             >> /etc/postfix/main.cf
    echo "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" >> /etc/postfix/main.cf
    echo "header_size_limit = 4096000"                             >> /etc/postfix/main.cf
    echo "smtp_sasl_security_options = noanonymous"                >> /etc/postfix/main.cf

	/etc/init.d/postfix start > /dev/null
fi
