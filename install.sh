#!/usr/bin/perl

use strict;
use warnings;

my @dirs = qw(automation group include scene sensor zone);

mkdir 'combined_config' unless -d 'combined_config';
foreach my $dir (@dirs) {
    `cp -r $dir combined_config` if -d $dir;
    `cp -r ../hass-private/$dir combined_config` if -d "../hass-private/$dir";
}

`rsync -aqt  configuration.yaml ~hass/.homeassistant`;
chmod 0644, '~hass/.homeassistant/configuration.yaml';
`chgrp hass  ~hass/.homeassistant/configuration.yaml`;

`rsync -aqt  ../hass-private/secrets.yaml ~hass/.homeassistant`;
chmod 0640, '~hass/.homeassistant/secrets.yaml';
`chgrp hass  ~hass/.homeassistant/secrets.yaml`;

`chgrp -R hass combined_config/*`;
`chmod -R g-w  combined_config/*`;
foreach my $dir (@dirs) {
    next unless -d "combined_config/$dir";
    `rsync -aqt --delete combined_config/$dir ~hass/.homeassistant`;
}

#`sudo systemctl restart home-assistant\@hass`;
`rm -rf combined_config`;
