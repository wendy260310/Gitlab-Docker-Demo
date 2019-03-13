FROM gitlab/gitlab-runner:latest
COPY entry.sh /
ENTRYPOINT ["/bin/bash","/entry.sh"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
