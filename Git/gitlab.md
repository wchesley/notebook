# Gitlab

- [Gitlab Docs](https://docs.gitlab.com/)

## TO-DO:
- pushing large changes wont' go through pubulic internet. Issue *should* lie with nginx hosted in cloud. See [this stackoverflow post](https://stackoverflow.com/questions/7489813/github-push-error-rpc-failed-result-22-http-code-413) for more. 
  - Have tested with client_max_body_size set to 100M, still wouldn't go through: http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size
  - workaround: set a branch pointing to local IP of gitlab instance. I just named mine local_master for working with this repo. 