#!/bin/bash

#!/bin/bash

TARGET=$(dirname $0)


NUM_PARTITIONS_PERSONS=$1

if [ -z "$2" ]; then
    NUM_PARTITIONS_AUCTIONS=$1
else
	NUM_PARTITIONS_AUCTIONS=$2
fi

if [ -z "$3" ]; then
    NUM_PARTITIONS_BIDS=$1
else
	NUM_PARTITIONS_BIDS=$3
fi

$TARGET/create-topics.sh nexmark_persons $NUM_PARTITIONS_PERSONS
$TARGET/create-topics.sh nexmark_auctions $NUM_PARTITIONS_AUCTIONS
$TARGET/create-topics.sh nexmark_bids $NUM_PARTITIONS_BIDS
