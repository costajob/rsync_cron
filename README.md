## Table of Contents

* [Scope](#scope)
* [Installation](#installation)
* [Usage](#usage)

# Scope
The scope of this gem is to install the specified `rsync` command into the `crontab` schedule.

# Installation
Install the gem from your shell:
```shell
gem install rsync_cron
```

# Usage
The gem comes with a CLI interface, you can print its help by:
```shell
rsync_cron -h
Usage: rsync_cron --cron='15,30 21' --src=/ --dest=/tmp --log=/var/log/rsync.log --opts=noatime,temp-dir='./temp'
    -c, --cron=CRON                  The cron string, i.e.: '15 21 * * *'
    -s, --src=SRC                    The rsync source, i.e. user@src.com:files
    -d, --dest=DEST                  The rsync dest, i.e. user@dest.com:home/
    -l, --log=LOG                    log command output to specified file
    -o, --opts=OPTS                  merge specified extra options
    -p, --print                      Print crontab command without installing it
    -k, --check                      Check src and dest before installing crontab
    -h, --help                       Prints this help
```

## Default schedule
The `crontab` is scheduled one per day by default (at midnight).  
You can specify a different schedule directly on the command line:
```shell
# run every sunday
rsync_cron --cron='* * * * 0' --src=user@src.com:files --dest=~/tmp
```
