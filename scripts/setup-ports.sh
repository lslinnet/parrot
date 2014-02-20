#!/bin/bash
sudo ipfw add 100 fwd 127.0.0.1,8181 tcp from any to any 80 in
sudo ipfw add 100 fwd 127.0.0.1,1443 tcp from any to any 443 in
