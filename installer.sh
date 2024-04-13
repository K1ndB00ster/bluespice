sudo yum -y install python3 nano dnf net-tools wget python python-devel mysql-devel redhat-rpm-config gcc iptables-services
sudo dnf install curl -y
pip3 install mysql-connector-python==8.0.29
pip3 install pymysql
pip3 install click
sudo touch bsclear.py
sudo chmod +x bsclear.py
echo '''import os
import pymysql

os.system('sudo yum -y install mariadb-server.x86_64 zip.x86_64')
os.system('sudo systemctl start mariadb && sudo systemctl enable mariadb && sudo systemctl start mariadb')
os.system('sudo systemctl status mariadb')
os.system('sudo dnf -y install httpd php php-mysqlnd php-xml php-intl php-mbstring php-gd php-json php-curl php-openssl wget php-zip')
os.system('sudo systemctl enable httpd')
os.system('sudo systemctl start httpd')
os.system('sudo dnf -y install epel-release')
os.system('sudo dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm')
os.system('sudo dnf module reset php')
os.system('sudo dnf module enable php:remi-8.0')
os.system('sudo dnf -y update')
os.system('sudo dnf -y install php')

bsport = open('/etc/httpd/conf.d/bluespice.conf', 'w+')
password = input('Enter password for your DB: ')
os.system(f'''mysql_secure_installation''')
mydb = pymysql.connect(
  host="localhost",
  user="root",
  passwd=f"{password}"
)
password2 = input('Repeat password for your DB: ')
userdb = input('Enter admin name: ')
dbname = input('Enter name for DB: ')
email = input('Enter your e-mail: ')
ServerName = input('Enter server name like "google.com": ')
InstallPath = input('Enter path to install: ')

mycursor = mydb.cursor()
mycursor.execute(f"CREATE DATABASE {dbname};")
mycursor.execute(f"CREATE USER '{userdb}'@'localhost' IDENTIFIED BY '{password2}';")
mycursor.execute(f"GRANT ALL PRIVILEGES ON {dbname}.* TO '{userdb}'@'localhost' WITH GRANT OPTION;")
mycursor.execute('FLUSH PRIVILEGES;')
mycursor.close()

os.system('sudo wget https://bluespice.com/filebase/bluespice-free')
os.system('sudo unzip bluespice-free')
os.system(f'sudo mv bluespice {InstallPath}')
os.system(f'sudo chown -R apache:apache {InstallPath}/bluespice')
os.system(f'sudo chmod -R 755 {InstallPath}/bluespice')
os.system('sudo touch /etc/httpd/conf.d/bluespice.conf')
bsport.write(f'''<VirtualHost *:80>
    ServerAdmin {email}
    DocumentRoot {InstallPath}/bluespice
    ServerName {ServerName}

    <Directory {InstallPath}/bluespice>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog {InstallPath}/bluespice_error.log
    CustomLog {InstallPath}/bluespice_access.log combined
</VirtualHost>
''')
bsport.close()
os.system(f'sudo mkdir {InstallPath}/bluespice/extensions/BlueSpiceFoundation/data')
os.system(f'sudo chown apache:apache {InstallPath}/bluespice/extensions/BlueSpiceFoundation/data')
os.system('cd')
os.system('sudo systemctl restart httpd')
with open('/etc/selinux/config', 'r') as f:
    old_data = f.read()

new_data = old_data.replace(f'SELINUX=enforcing', f'SELINUX=disabled')

with open('/etc/selinux/config', 'w') as f:
    f.write(new_data)

with open('/etc/firewalld/firewalld.conf', 'r') as f:
    old_data = f.read()

new_data = old_data.replace(f'AllowZoneDrifting=yes', f'AllowZoneDrifting=no')

with open('/etc/firewalld/firewalld.conf', 'w') as f:
    f.write(new_data)
os.system('sudo firewall-cmd --add-service=http --permanent')
os.system('sudo firewall-cmd --add-service=https --permanent')
os.system('sudo firewall-cmd --add-port=80/tcp --permanent')
os.system('sudo systemctl restart firewalld')
''' > bsclear.py
sudo python3 bsclear.py
