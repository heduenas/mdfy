mkdir 1; mkdir 1/statements
mkdir 2; mkdir 2/statements
mkdir 3; mkdir 3/statements
mkdir 4; mkdir 4/statements
mkdir 5; mkdir 5/statements
mkdir 6; mkdir 6/statements
mkdir 7; mkdir 7/statements
mkdir 8; mkdir 8/statements

python3 mdfy.py ch01.tex 1/statements/en.markdown
python3 mdfy.py ch02.tex 2/statements/en.markdown
python3 mdfy.py ch03.tex 3/statements/en.markdown
python3 mdfy.py ch04.tex 4/statements/en.markdown
python3 mdfy.py ch05.tex 5/statements/en.markdown
python3 mdfy.py ch06.tex 6/statements/en.markdown
python3 mdfy.py ch07.tex 7/statements/en.markdown
python3 mdfy.py ch08.tex 8/statements/en.markdown

cp 1/statements/en.markdown 1/statements/es.markdown
cp 2/statements/en.markdown 2/statements/es.markdown
cp 3/statements/en.markdown 3/statements/es.markdown
cp 4/statements/en.markdown 4/statements/es.markdown
cp 5/statements/en.markdown 5/statements/es.markdown
cp 6/statements/en.markdown 6/statements/es.markdown
cp 7/statements/en.markdown 7/statements/es.markdown
cp 8/statements/en.markdown 8/statements/es.markdown

sudo apt install dia
cd figs
for D in *.dia; do dia -t png -s 600x $D; done
cd ..

cp -r figs/* 1/statements
cp -r figs/* 2/statements
cp -r figs/* 3/statements
cp -r figs/* 4/statements
cp -r figs/* 5/statements
cp -r figs/* 6/statements
cp -r figs/* 7/statements
cp -r figs/* 8/statements

zip -r 1.zip 1/
zip -r 2.zip 2/
zip -r 3.zip 3/
zip -r 4.zip 4/
zip -r 5.zip 5/
zip -r 6.zip 6/
zip -r 7.zip 7/
zip -r 8.zip 8/

rm -r 1/
rm -r 2/
rm -r 3/
rm -r 4/
rm -r 5/
rm -r 6/
rm -r 7/
rm -r 8/
