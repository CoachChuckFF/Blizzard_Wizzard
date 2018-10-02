#! /bin/bash

rm fixture.list

cd ./fix

for filename in *.fix; do
    [ -e "$filename" ] || continue
    BRAND_LINE="$(grep '<brand' $filename)"
    BRAND="$(echo $BRAND_LINE | sed -n 's/.*name="\([^"]*\).*/\1/p')"
    FIXTURE_LINE="$(grep '<fixture' $filename)"
    FIXTURE="$(echo $FIXTURE_LINE | sed -n 's/.*name="\([^"]*\).*/\1/p')"
    echo "WSFixtureType('$BRAND', '$FIXTURE', '$filename')," >> ../fixture.list
done