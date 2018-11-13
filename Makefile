all:
	git add *
	git commit
	git push

pull:
	git pull origin master

push:
	git commit
	git push

pdf:
	okular enunciado-p2.pdf&

add:
	git add Makefile *.txt *.pdf *.jpg *.PNG *.mdzip *.bak 
