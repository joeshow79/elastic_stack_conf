#!/bin/bash

for index in $(curl  -s 'http://localhost:9200/_cat/shards' | grep UNASSIGNED | awk '{print $1}' | sort | uniq); do
    for shard in $(curl  -s 'http://localhost:9200/_cat/shards' | grep UNASSIGNED | grep $index | awk '{print $2}' | sort | uniq); do
        echo  ">>>" $index $shard

        curl -XPOST 'localhost:9200/_cluster/reroute' -d "{
            'commands' : [ {
                  'allocate' : {
                      'index' : $index,
                      'shard' : $shard,
                      'node' : 'es01',
                      'allow_primary' : true
                  }
                }
            ]
        }"

        sleep 5
    done
done
