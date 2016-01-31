build:
	mkdir build/
	mkdir build/scripts
	cp init.lua build/init.luatemp
	cp scripts/* build/scripts/
	touch build/init.lua
	echo "local WIFISSID = \"$(WIFISSID)\";" >> build/init.lua
	echo "local WIFIPASSWORD = \"$(WIFIPASSWORD)\";" >> build/init.lua
	echo "local HOSTNAME = \"$(HOSTNAME)\";" >> build/init.lua
	cat build/init.luatemp >> build/init.lua
	rm build/init.luatemp
clean:
	rm -rf build

acp:
	#im lazy
	make clean
	git add --all
	git commit -m "$(m)"
	git push


