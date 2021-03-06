#Timezone
timedatectl set-timezone Asia/Tokyo

#Java 8
sudo add-apt-repository -y ppa:openjdk-r/ppa

apt-get update

#MySQL
MYSQL_ROOT_PASS="pass"
echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASS" | debconf-set-selections
apt-get -y install mysql-server

#to access MySQL from host
sed -i -e 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/my.cnf
service mysql restart

#phpMyAdmin
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password ''" | debconf-set-selections
apt-get -y install phpmyadmin
sudo php5enmod mcrypt

#PEAR
apt-get -y install php-http-request

#for abraham/twitteroauth
apt-get -y install git php5-curl

#display PHP errors
sed -i -e 's/display_errors = Off/display_errors = On/' /etc/php5/apache2/php.ini
service apache2 restart

#other
apt-get -y install jq unzip nkf
apt-get -y autoremove

curl -s https://raw.githubusercontent.com/taroyabuki/webbook2/master/src/07/7.1--7.5%20SQL%E3%81%AE%E5%9F%BA%E6%9C%AC.sql | mysql -uroot -ppass > /dev/null 2>&1
curl -s https://raw.githubusercontent.com/taroyabuki/webbook2/master/src/08/%E3%83%A6%E3%83%BC%E3%82%B6%E7%AE%A1%E7%90%86%E3%83%86%E3%83%BC%E3%83%96%E3%83%AB.sql | mysql -uroot -ppass mydb > /dev/null 2>&1

wget http://www.post.japanpost.jp/zipcode/dl/oogaki/zip/ken_all.zip > /dev/null 2>&1
wget http://www.post.japanpost.jp/zipcode/dl/jigyosyo/zip/jigyosyo.zip > /dev/null 2>&1
unzip ken_all.zip
unzip jigyosyo.zip
nkf -w KEN_ALL.CSV > /root/ken_all_utf8.csv
nkf -w JIGYOSYO.CSV > /root/jigyosyo_utf8.csv
rm -rf /home/ubuntu/*

curl -s https://raw.githubusercontent.com/taroyabuki/webbook2/master/src/09/zips.sql | mysql -uroot -ppass --local-infile mydb > /dev/null 2>&1
