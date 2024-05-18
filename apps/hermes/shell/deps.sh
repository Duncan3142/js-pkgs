#! /usr/bin/env bash

sudo dnf --setop=install_weak_deps=False group install -y 'Development Tools' 'C Development Tools and Libraries'

sudo dnf --setop=install_weak_deps=False install -y autoconf ncurses-devel wxGTK-devel wxBase openssl-devel java-1.8.0-openjdk-devel libiodbc unixODBC-devel libxslt fop
