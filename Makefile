# simple dirwall install Makefile

SYSVLINK="/etc/rc2.d"
RCSCRIPT="/etc/init.d"

dirwall :

install :
	@[ -e "/etc/dirwall" ] && echo "/etc/dirwall dir already exists, skipping.." || ( cp -r etc/dirwall /etc; echo "installed: /etc/dirwall" )
	@[ -e "$(RCSCRIPT)/dirwall" ] && echo "$(RCSCRIPT)/dirwall file already exists, skipping.." || ( cp etc/init.d/dirwall $(RCSCRIPT); chmod a+rx $(RCSCRIPT)/dirwall; echo "installed: $(RCSCRIPT)/dirwall" )
	@[ -h "$(SYSVLINK)/S19dirwall" ]  && echo "$(SYSVLINK)/S19dirwall link already exists, skipping.." || ( ln -s $(RCSCRIPT)/dirwall $(SYSVLINK)/S19dirwall; echo "installed: $(SYSVLINK)/S19dirwall" )

remove :
	@[ ! -e "/etc/dirwall" ] && echo "/etc/dirwall dir dosn't exist, skipping.." || ( echo "please remove /etc/dirwall manually" )
	@[ ! -e "$(RCSCRIPT)/dirwall" ] && echo "$(RCSCRIPT)/dirwall file dosn't exist, skipping.." || ( rm $(RCSCRIPT)/dirwall; echo "removed: $(RCSCRIPT)/dirwall" )
	@[ ! -h "$(SYSVLINK)/S19dirwall" ]  && echo "$(SYSVLINK)/S19dirwall link dosn't exist, skipping.." || ( rm $(SYSVLINK)/S19dirwall; echo "removed: $(SYSVLINK)/S19dirwall" )

