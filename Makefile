# Makefile for setting up OpenEBS.
#
# Reference Guide - https://www.gnu.org/software/make/manual/make.html


#
# This is done to avoid conflict with a file of same name as the targets
# mentioned in this makefile.
#
.PHONY: help clean build install _install_make_conf _install_binary _post_install_msg _install_git_base_img _clean_git_base_img _clean_binaries _install_openebs_conf_dir _build_check_go _build_check_lxc _install_check_openebs_daemon

#
# Internal variables or constants.
# NOTE - These will be executed when any make target is invoked.
#
IS_OPENEBSD_RUNNING       := $(shell ps aux | grep -v grep | grep -c openebsd)
IS_GO_INSTALLED           := $(shell which go >> /dev/null 2>&1; echo $$?)
IS_LXC_INSTALLED          := $(shell which lxc-create >> /dev/null 2>&1; echo $$?)

#
# The first target is the default.
# i.e. 'make' is same as 'make help'
#
help:
	@echo ""
	@echo "Usage:-"
	@echo "\tmake clean              -- will remove openebs binaries from $(GOPATH)/bin"
	@echo "\tmake build              -- will build openebs binaries"
	@echo "\tmake install            -- will build & install the openebs binaries"
	@echo ""


#
# Will remove the openebs binaries at $GOPATH/bin
#
_clean_git_base_img:
	@echo ""
	@echo "INFO:\tremoving openebs base img repos and tar file ..."
	@rm -rf ../vsm-image
	@rm -rf ../tgt
	@rm -f ../base.tar.gz
	@echo "INFO:\topenebs base img repos and tar file removed successfully ..."
	@echo ""


#
# Will remove the openebs binaries at $GOPATH/bin
#
_clean_binaries:
	@echo ""
	@echo "INFO:\tremoving openebs binaries from $(GOPATH)/bin ..."
	@rm -f $(GOPATH)/bin/openebs
	@rm -f $(GOPATH)/bin/openebsd
	@echo "INFO:\topenebs binaries removed successfully from $(GOPATH)/bin ..."
	@echo ""


#
# The clean target to be used by user.
#
clean: _clean_git_base_img _clean_binaries


_build_check_go:
	@if [ $(IS_GO_INSTALLED) -eq 1 ]; \
		then echo "" \
		&& echo "ERROR:\tgo is not installed. Please install it before build." \
		&& echo "Refer:\thttps://github.com/openebs/openebs#building-from-sources" \
		&& echo "" \
		&& exit 1; \
		fi;


#
# Will build the go based binaries
# The binaries will be placed at $GOPATH/bin/
#
build: _build_check_go
	@echo ""
	@echo "INFO:\tverifying dependencies for openebs ..."
	@glide up
	@echo "INFO:\tbuilding openebs ..."
	@go install github.com/openebs/openebs/cmd/openebs
	@go install github.com/openebs/openebs/cmd/openebsd
	@echo "INFO:\topenebs built successfully ..."
	@echo ""



_install_check_openebs_daemon:
	@if [ $(IS_OPENEBSD_RUNNING) -eq 1 ]; \
		then echo "" \
		&& echo "ERROR:\topenebsd is running. It needs to be stopped before re-install." \
		&& echo "" \
		&& exit 1; \
		fi;


#
# Internally used target.
# Will create openebs config directory structure.
#
_install_openebs_conf_dir:
	@mkdir -p /etc/openebs/.vsms



#
# Internally used target.
# Will fetch the latest jiva image from dockerhub
#
_install_fetch_img:
	@echo ""
	@echo "Fetch the latest jiva image"
	docker pull openebs/jiva:ac151f2-dirty
	@echo ""


#
# Internally used target.
# Will place the openebs make configs at /etc/openebs/make
#
_install_make_conf: 
	@echo ""
	@echo "INFO:\tinstalling openebs make confs ..."
	@rm -rf /etc/openebs/make
	@cp -rp ./etc/openebs/make/ /etc/openebs/make
	@echo "INFO:\topenebs make confs installed successfully ..."
	@echo ""


#
# Internally used target.
# Will place the openebs binaries at /sbin/
#
_install_binary:
	@echo ""
	@echo "INFO:\tinstalling openebs binaries ..."
	@sudo cp $(GOPATH)/bin/openebs /sbin/
	@sudo cp $(GOPATH)/bin/openebsd /sbin/
	@echo "INFO:\topenebs binaries installed successfully ..."
	@echo ""


#
# Internally used target.
# Will post a simple usage message.
#
_post_install_msg:
	@echo ""
	@echo "--------------------------------------------------------------------"
	@echo "INFO:\tRun openebs to use the CLI"
	@echo "INFO:\tRun either of below to start the deamon"
	@echo ""
	@echo "NOTE:\tYou will need root(or sudo) previleges to run openebs"
	@echo ""
	@echo "INFO:\tsocket mode:"
	@echo "     \tnohup openebsd >> openebsd.log 2>&1 &"
	@echo ""
	@echo "INFO:\ttcp mode:"
	@echo "     \tnohup openebsd -H tcp://0.0.0.0:8000 >> openebsd.log 2>&1 &"
	@echo ""
	@echo "INFO:\tWhen daemon is in tcp mode, set below before running openebs commands:"
	@echo "     \te.g. export OPENEBS_HOST=\"tcp://0.0.0.0:8000\""
	@echo ""
	@echo "--------------------------------------------------------------------"
	@echo ""

#
# The install target to be used by Admin.
#
install: _install_check_openebs_daemon build _install_openebs_conf_dir _install_make_conf _install_fetch_img _install_binary _post_install_msg

