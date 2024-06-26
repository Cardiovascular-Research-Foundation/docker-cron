FROM ubuntu:22.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install -y cron  ca-certificates openssl curl \
    # Remove package lists for smaller image sizes
    && rm -rf /var/lib/apt/lists/* \
	&& which cron \
    && rm -rf /etc/cron.*/*
		
# Copy the crontab file and entrypoint script into the container
COPY crontab /hello-cron
COPY entrypoint.sh /entrypoint.sh

# Install the crontab and make the entrypoint script executable
RUN crontab /hello-cron \
    && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# https://manpages.ubuntu.com/manpages/trusty/man8/cron.8.html
# -f | Stay in foreground mode, don't daemonize.
# -L loglevel | Tell  cron  what to log about jobs (errors are logged regardless of this value) as the sum of the following values:
CMD ["cron","-f", "-L", "2"]
