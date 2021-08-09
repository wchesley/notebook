# Useful Commands

Frequently used commands. This is a helpful page to [add to your Favorites](https://www.notion.so/Navigating-with-the-sidebar-7ef7287cee00464d9a813073b02ce24a).

# 🚚 Run Locally

In the `acme` directory, run: 

```bash
acme run --local
```

For a full list of options, use:

```bash
acme --help
```

To run the typechecker on the entire codebase:

```bash
acme typecheck
```

# 🚢 Deployment

When you deploy to staging or production, run the following on the deployment server:

```bash
acme deploy --staging 
```

Replace `--staging` with `--prod` if deploying production.