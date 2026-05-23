
clash-dashboard: metacubexd
	sudo mv metacubexd-gh-pages /var/www/clash

metacubexd:
	curl -LO https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.zip
	unzip -o gh-pages.zip

.PHONY: clean
clean:
	-rm gh-pages.zip

