
aggr := aggressive.makefile
%/: FORCE
	@cp $(aggr) ./$@/$(aggr)
	@make -f $(aggr) -C ./$@ lib_dir=../lib
	@rm -f ./$@/$(aggr)
.PHONY: FORCE