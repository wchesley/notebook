# Migrate GhostCMS SQLite to MySQL

Recently, I finally managed to upgrade my old Ghost instance running the 4.x.x release on SQLite to the latest 5.x.x release on MySQL.

I had attempted this upgrade multiple times without success, but now everything works perfectly. Here’s how I did it:

0.  Backup everything, just in case.
1.  Upgrade to version `5.8.3`. AFAIK this is the latest version that still supports SQLite.
2.  Set up a fresh MySQL instance.
3.  Create the database and user.
    -   Create a database named `ghost`.
    -   Create a user `ghost` with the appropriate permissions for the `ghost` database.
    -   Use the collation `utf8mb4_0900_ai_ci` for the database.
4.  Modify your `config.production.json` file to point to the new MySQL instance:

```json
"database": {
"client": "mysql",
"connection": {
    "host": "your-mysql-host.domain.com",
    "user": "ghost",
    "password": "password",
    "database": "ghost",
    }
},
``` 

5.  Restart Ghost. Ghost will run migrations on the new database and create the required tables.
6.  Download the `ghost.db` SQLite database file from your Ghost instance.
7.  Download and install the [sqlite3-to-mysql](https://github.com/techouse/sqlite3-to-mysql) tool.
8.  Run `sqlite3mysql --sqlite-file 'ghost.db' --mysql-host your-mysql-host.domain.com --mysql-user ghost --mysql-database ghost --mysql-skip-create-tables --without-foreign-keys --mysql-truncate-tables`. This tool will populate your MySQL database using the backup.
9.  Restart Ghost, Check that everything is running smoothly.
10.  Perform incremental upgrades. I didn’t attempt to upgrade in one leap. Instead, I upgraded in steps: `5.8.3`→`5.39.0`→`5.57.2`→`5.76.1`→`5.105.0`
11.  …
12.  PROFIT!

I know the official guides recommend a full reinstall, but I preferred avoiding the hassle of dealing with media files and other settings.

Hope this helps!

- [reference](https://forum.ghost.org/t/upgrading-ghost-from-sqlite-to-mysql-guide/53592)
- [sqlite-to-mysql](https://github.com/techouse/sqlite3-to-mysql) (requires python & pip)