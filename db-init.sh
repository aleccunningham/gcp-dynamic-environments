/usr/bin/mysqladmin -uroot password root && \
/usr/bin/mysql -uroot -proot -e "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES" && \
/usr/bin/mysql -u root -proot -e "CREATE DATABASE $DB_NAME" && \
