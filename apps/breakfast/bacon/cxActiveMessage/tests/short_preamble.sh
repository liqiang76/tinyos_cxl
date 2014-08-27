#!/bin/bash
set -x 
declare -A idMapping
#root
idMapping[JH000368]=0
#high
idMapping[JH000323]=1 
#low
idMapping[JH000367]=2
idMapping[JH000301]=3
idMapping[JH000300]=4
idMapping[JH000357]=5
#sniffer
idMapping[JH000353]=6
#unused
idMapping[JH000356]=7

pgrep -f 'python rawSerialTS.py' | xargs kill

testDuration=$((60 * 5))
for i in $(seq 1 1000)
do
  #12 combinations: 1 hour per cycle
  # 4 maps
  #+ 0, 6, 10, none
  for highMap in dmap/dmap.high.0 dmap/dmap.high.6 dmap/dmap.high.10 dmap/dmap.none
  do
    # 3 maps
    #none, 1, 4
    for lowMap in dmap/dmap.none dmap/dmap.low.1 dmap/dmap.low.4
    do
      #kill any dumps
      pgrep -f 'python rawSerialTS.py' | xargs kill

      ./installDesktopVariablePower.sh \
        testLabel $(basename $highMap).$(basename $lowMap).$i \
        snifferMap dmap/dmap.sniffer \
        rootMap dmap/dmap.root \
        receiverMap $lowMap \
        receiverMap2 $highMap \
        fps 4 \
        forceSlots 4 \
        maxDepth 2 

      #start up serial dumps
      for d in /dev/ttyUSB*
      do
        ref=$(motelist | awk --assign dev=$d '($2 == dev){print $1}')
        nodeId=${idMapping[$ref]}
        python rawSerialTS.py $d --label $nodeId --reset 1\
          >> desktop/$nodeId.log &
      done
      sleep $testDuration

      #kill 'em
      pgrep -f 'python rawSerialTS.py' | xargs kill
    done
  done
done
