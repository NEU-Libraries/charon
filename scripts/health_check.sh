#!/bin/bash
wget --spider --server-response localhost:3000/healthcheck 2>&1 | grep '200\ OK' | wc -l
