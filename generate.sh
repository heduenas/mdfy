#!/bin/bash

sudo apt install dia;
cd figs;
for D in *.dia; do dia -t png -s 600x $D; done
cd ..;

for i in {1..8}
do
    # Remove old directory
    rm -r $i;
    # Create chapter directory.
    mkdir $i;
    # MDfy tex file.
    python3 mdfy.py ch0$i.tex $i/$i.markdown;
    # Step into chapter subdirectory.
    cd $i;
    # Split file, one file per subsection.
    csplit -z -n 1 --prefix "" $i.markdown /##\ / '{*}';
    # Delete full file.
    rm $i.markdown;

    # Move subsection into their own directories.
    for D in *
    do
        mkdir "$i.${D}";
        mkdir "$i.${D}/statements";
        mv $D $i.$D/statements/en.markdown;
        printf "\n\n<sub>Este texto está basado en el libro [Think Java](https://greenteapress.com/wp/think-java-2e/) de Allen Downey y Chris Mayfield y está disponinble bajo la licencia [Creative Commons Attribution-NonCommercial-ShareAlike 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).</sub>" >> $i.$D/statements/en.markdown;
        cp $i.$D/statements/en.markdown $i.$D/statements/es.markdown;
        cp ../figs/* $i.$D/statements;

        zip -r $i.$D.zip $i.$D/
        
        rm -r $i.$D/
    done;

    # Step back.
    cd ..;
done
