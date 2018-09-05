#! /bin/sh
LOGS=`find . -name "*.log"`
for a in $LOGS; do
    section=`echo $a | sed 's/[^[:alnum:]]/_/g;'`
    echo "###########################################################################"
    echo "travis_fold:start:${section}"
    echo "###LOG### $a ##############################"
    echo "###########################################################################"
    cat "$a"
    echo "travis_fold:end:${section}"
done
