#!/bin/sh

DOC=doc

if [ -d "$DOC" ]; then
    echo 'Borrando documentacion anticuada'
    rm -r $DOC
fi

rdoc --all

echo 'Creada la nueva documentacion'