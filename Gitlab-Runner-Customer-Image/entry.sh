gitlab-runner register -n  --url http://docker.for.mac.host.internal    --registration-token dzasd7-PuX1e3z3KRgFJ   --executor docker   --description "my customer runner"   --docker-image "docker:latest"   --docker-volumes /var/run/docker.sock:/var/run/docker.sock
exec /usr/bin/dumb-init /entrypoint "$@"

