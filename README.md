## Table of Contents

* [Scope](#scope)
* [Installation](#installation)
* [Usage](#usage)

# Scope
The scope of this gem is to wrap the `rsync` command and to trigger it via the `crontab` schedule.

# Installation
Install the gem from your shell:
```shell
gem install rsync_cron
```

# Usage
The gem comes with a CLI interface. You can print its help by:
```shell
rsync_cron -h
Usage: rsync_cron --cron=15,30 21 * * * --src=/ --dest=/tmp --log=/var/log/rsync.log
    -c, --cron=CRON                  The cron string, i.e.: 15 21 * * *
    -s, --src=SRC                    The rsync source, i.e. user@src.com:files
    -d, --dest=DEST                  The rsync dest, i.e. user@dest.com:home/
    -l, --log=LOG                    log command output to specified file
    -h, --help                       Prints this help
```

## Default schedule
The `crontab` is scheduled one per day by default (at midnight).  
You can specify a different value directly on the command line:
```shell
# run every sunday
rsync_cron --cron=* * * * 0 --src=user@src.com:files --dest=~/tmp
```

## Log to a file
Is possible to log the `rsync` output to a file:
```shell
rsync_cron --src=user@src.com:files --dest=~/tmp --log=./rsync.log
```

