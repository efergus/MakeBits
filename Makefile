
test_var := A/notmake
test:
	echo $(patsubst %.%, , $(wildcard *))

notmake:
	make -C A -f notmake