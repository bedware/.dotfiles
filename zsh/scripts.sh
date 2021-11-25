#!/bin/bash

compress() {
    tar cvzf $1.tar.gz $1
}

wikipedia() {
    lynx -vikeys -accept_all_cookies "https://en.wikipedia.org/wiki/$@"
}

