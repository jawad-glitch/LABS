FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install -y --no-install-recommends openssh-server sudo ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /run/sshd \
 && useradd -m -s /bin/bash ansible \
 && usermod -p '*' ansible \
 && echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible \
 && chmod 440 /etc/sudoers.d/ansible \
 && mkdir -p /home/ansible/.ssh && chmod 700 /home/ansible/.ssh \
 && sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
COPY ansible_lab.pub /home/ansible/.ssh/authorized_keys
RUN chown -R ansible:ansible /home/ansible/.ssh && chmod 600 /home/ansible/.ssh/authorized_keys
EXPOSE 22 80
CMD ["/usr/sbin/sshd", "-D", "-e"]
