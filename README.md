## Table of Contents

* [Scope](#scope)
* [Installation](#installation)
* [Warning](#warning)
* [Usage](#usage)

# Scope
The scope of this gem is to install the specified `rsync` command into the `crontab` schedule.

# Installation
Install the gem from your shell:
```shell
gem install rsync_cron
```

# Warning
Be aware that this library will write to the `crontab` file in a destructive way.  
Do remember to take a backup before installing a new `crontab`.

# Usage
The gem comes with a CLI interface, you can print its help by:
```shell
rsync_cron -h
Usage: rsync_cron --cron='15,30 21' --src=/ --dest=/tmp --log=/var/log/rsync.log --opts=noatime,temp-dir='./temp'
    -c, --cron=CRON                  The cron string, i.e.: '15 21 * * *'
    -s, --src=SRC                    The rsync source, i.e. user@src.com:files
    -d, --dest=DEST                  The rsync dest, i.e. user@dest.com:home/
    -l, --log=LOG                    Log command output to specified file
    -o, --opts=OPTS                  Merge specified extra options, when supported
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
