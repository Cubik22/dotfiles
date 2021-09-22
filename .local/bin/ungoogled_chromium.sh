#!/bin/sh

exec chromium --force-dark-mode --enable-features=UseOzonePlatform,WebUIDarkMode --ozone-platform=wayland
