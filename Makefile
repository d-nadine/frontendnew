LESS_COMPRESSOR ?= `which lessc`
WATCHR ?= `which watchr`

watch:
	echo "Watching less files..."; \
	watchr -e "watch('less/.*\.less') { |f| system('lessc less/bootstrap.less > stylesheets/bootstrap.css') }"


.PHONY: watch