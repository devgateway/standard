#!/bin/bash
git fetch
git checkout 1.0-dev-pseudolocalization
cp pseudolocalize.sh pseudolocalize.bak
git reset --hard 1.0-dev
mv pseudolocalize.bak pseudolocalize.sh
git add pseudolocalize.sh

./build_docs.sh

# pybabel compile must allow fuzzy for this build to work
sed -i 's/pybabel compile/pybabel compile -f/' build_docs.sh
# pull in pseudolocalized theme in requirements.txt
sed -i 's/@open_contracting#/@pseudolocalization#/g' requirements.txt

pushd .ve/src/standard-theme
    git checkout pseudolocalization
    git reset --hard open_contracting
    podebug --rewrite=unicode  -i locale/sphinx.pot > locale/es/LC_MESSAGES/sphinx.po
    git commit -m 'Scripted pseudolocalization commit' -a
popd

pushd standard/docs/locale/es/LC_MESSAGES/
for f in *.po */*.po
do
    podebug --rewrite=unicode  -i ../../../../../build/locale/${f}t > $f
done
popd

./build_docs.sh
git commit -m 'Scripted pseudolocalization commit' -a
