# PayloadCMS

Payload is a headless CMS and application framework. It's meant to provide a massive boost to your development process, but importantly, stay out of your way as your apps get more complex.

Out of the box, Payload gives you a lot of the things that you often need when developing a new website, web app, or native app:

- A database to store your data (Postgres and MongoDB supported)
- A way to store, retrieve, and manipulate data of any shape via full REST and GraphQL APIs
- Authentication—complete with commonly required functionality like registration, email verification, login, & password reset
- Deep access control to your data, based on document or field-level functions
- File storage and access control
- A beautiful admin UI that's generated specifically to suit your data


## Notes: 

- if you've scaffolded your website (seeded from admin dashboard) there's some white-labling that needs to be done in `/src/app/_heros/PostHero` and `ProjectHero` to remove a link to the admin page. 
- If you can't edit something in the web panel, head to the code. it's fairly logical, if a bit separated, by default. 
- Admin custom components [here](https://payloadcms.com/docs/admin/components) Docs actually aren't half bad...used seeded code for reference and was basically plug n' play from there. 

## Installation:

This assumes you are working with a fresh installation of Ubuntu 22.04 Server: 

PayloadCMS requires the following: 

- PostgreSQL or MongoDB
- NodeJS v16+
- Javascript package manager (Yarn, NPM, or pnpm)

### NodeJS Installation

Head to nodesource on github: https://github.com/nodesource/distributions
Follow instructions in README to install NodeJS, any version above v16 will work. This guide was written using NodeJS v21.x
**********************************************************NodeJS 21.x install command:********************************************************** 

`curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - &&\
sudo apt-get install -y nodejs`

- This will also install `npm` as a package manager.
    - You can confirm this, post NodeJS installation via `npm --version`

### PostgreSQL Setup:

This assumes you already have NodeJS, PayloadCMS installed and an empty payload project. 

- Install PostgreSQL via apt (your package manager or source)
- Switch to postgres (from root account) `su postgres`
- Enter PSQL shell via `psql` command.
- Configure a user for payloadCMS to talk to postgres with: 
`CREATE USER payload WITH SUPERUSER LOGIN REPLICATION BYPASSRLS` 
  - TODO: Figure out most basic permissions payloadCMS needs against Postgres and assign it only that.
- Then set password for new `payload` user: 
`\password payload`

### PayloadCMS Installation

Payload with PostgreSQL will come in two parts, each installed via `npm` or your JS package manager. 

- Create Payload App: 
`npm i create-payload-app`
- Payload Postgres Adapter: 
`npm i @payloadcms/db-postgres`

Scaffold a payload application, choosing website as the template and postgreSQL as the database back-end. 

`npx create-payload-app@latest`

Once the app is created, change into it’s root directory and edit the `.env` file: 

- Edit payloadCMS’ `.env` file to update the Database connection string to: 
`postgres://username:password@localhost:5432`
    - Where we are only adding in `username:password` to this string.

Ensure you are in the projects root directory then, from here you can run `npm run dev` and get payload working at `http://localhost:3000`. 

Seed the database or begin creating your own pages and posts. You’re payloadCMS instance is now set up and working! 

# References:

https://www.postgresql.org/docs/14/sql-createuser.html

https://www.postgresql.org/docs/

https://github.com/nodesource/distributions

https://www.npmjs.com/package/create-payload-app

https://www.npmjs.com/package/@payloadcms/db-postgres

https://payloadcms.com/docs/getting-started/installation