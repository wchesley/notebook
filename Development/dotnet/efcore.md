[back](./README.md)

# Entity Framework Core - EFCore

EF Core is a modern object-database mapper for .NET. It supports LINQ queries, change tracking, updates, and schema migrations. EF Core works with SQL Server, Azure SQL Database, SQLite, Azure Cosmos DB, MySQL, PostgreSQL, and other databases through a provider plugin API.
## Installation

EF Core is available on NuGet. Install the provider package corresponding to your target database. See the list of providers in the docs for additional databases.

    dotnet add package Microsoft.EntityFrameworkCore.SqlServer
    dotnet add package Microsoft.EntityFrameworkCore.Sqlite
    dotnet add package Microsoft.EntityFrameworkCore.Cosmos

Use the `--version`` option to specify a preview version to install.

## Migrations and Migration Management

Just use EFCore to control the database. Don't go into the DB directly to make changes to it's structure else EFCore will more than likely freak-out and complain that things aren't there that actually are and visa versa. Use a DB Manager (DBeaver, DBbrowser, SQLiteStudio) or EFCore to manage the database but NOT both. 

### Reset Migrations

ref: https://stackoverflow.com/questions/11679385/reset-entity-framework-migrations

The Issue: You have mucked up your migrations and you would like to reset it without deleting your existing tables.

The Problem: You can't reset migrations with existing tables in the database as EF wants to create the tables from scratch.

What to do:

- Delete existing migrations from Migrations_History table.

- Delete existing migrations from the Migrations Folder.

- Run add-migration Reset. This will create a migration in your Migration folder that includes creating the tables (but it will not run it so it will not error out.)

- You now need to create the initial row in the MigrationHistory table so EF has a snapshot of the current state. EF will do this if you apply a migration. However, you can't apply the migration that you just made as the tables already exist in your database. So go into the Migration and comment out all the code inside the "Up" method.

- Now run update-database. It will apply the Migration (while not actually changing the database) and create a snapshot row in MigrationHistory.

You have now reset your migrations and may continue with normal migrations.
