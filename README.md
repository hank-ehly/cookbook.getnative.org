# cookbook.getnative.org

[![CircleCI](https://circleci.com/gh/hank-ehly/cookbook.getnative.org/tree/master.svg?style=svg&circle-token=63d578368c03639b7b68797d168a536ff5a50651)](https://circleci.com/gh/hank-ehly/cookbook.getnative.org/tree/master)

### Moving web servers

Follow these steps when switching web servers.

1. Backup the current letsencrypt cert data.

```bash
cd /etc/apache2
tar zcvf ssl.tar.gz ssl
```

2. Create the getnative user with root privileges on the new server.

```bash
sudo useradd -m -s /bin/bash -U getnative
sudo passwd getnative
> Changing password for user getnative.
> New password: <password>
> Retype new password: <password>
> passwd: all authentication tokens updated successfully.
sudo visudo
> getnative ALL=(ALL:ALL) NOPASSWD:ALL
```

3. Copy your local ssh-key to the getnative users authenticated_keys list

```bash
ssh-copy-id -i ~/.ssh/stg.getnative.org/getnative getnative@12.34.56.78
```

4. Update the IP address of your local stg.getnative.org ssh config

```bash
Host stg.getnative.org
    HostName               <new machine ip>
    PasswordAuthentication no
    IdentitiesOnly         yes
```

5. Run chef web role (except letsencrypt recipe) on new server

```bash
cd provision
bundle exec knife solo prepare getnative@stg.getnative.org -i ~/.ssh/stg.getnative.org/getnative
./bin/stg-dev-cook.bash
```

6. Change the IP address of DNS records to match the new machine IP

7. Update IP in deploy.rb and deploy client/docs/server applications to new machine

8. Upload secret files to new server application folder

- Google Cloud Platform credentials
- `cd api.getnative.org && ./bin/generate-jwt-keypair.bash`
- Oauth credentials

9. Copy letsencrypt files to new web server

```bash
scp ssl.tar.gz remote:/home/getnative/
# .. login as getnative user ..
cd ~
mv ssl.tar.gz /etc/apache2/
cd /etc/apache2
rmdir ssl
tar zxvf ssl.tar.gz
rm -f ssl.tar.gz
```

10. Run letsencrypt script on new machine

```bash
/usr/bin/letsencrypt renew --config-dir /etc/apache2/ssl --agree-tos --email admin@getnative.org [--dry-run]
```

11. Run vhost chef recipe on new host

```bash
vi nodes/stg.getnative.org.json
>    "run_list": [
>        "recipe[getnative.org-cookbook::vhost]"
>    ]
```

12. If you changed the deploy key, upload the new key to GitHub under {Environment} - multi-role in the user settings.
