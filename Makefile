
test_var := A/notmake
test:
	echo $(test_var)

notmake:
	make -C A -f notmake