.PHONY: echo
echo:
	echo "Printing..."

.PHONY: clean
clean:
	echo "Cleaning..."
	make app__clean
	make infrastructure__clean

app__%:
	${MAKE} --directory app -f make.mk $*

infrastructure__%:
	${MAKE} --directory infrastructure -f make.mk $*
