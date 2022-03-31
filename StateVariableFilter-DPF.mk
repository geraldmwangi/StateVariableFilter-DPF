######################################
#
# StateVariableFilter-DPF
#
######################################

# where to find the source code - locally in this case
STATEVARIABLEFILTER_DPF_SITE_METHOD = local
STATEVARIABLEFILTER_DPF_SITE = $($(PKG)_PKGDIR)/

# even though this is a local build, we still need a version number
# bump this number if you need to force a rebuild
STATEVARIABLEFILTER_DPF_VERSION = 1

# dependencies (list of other buildroot packages, separated by space)
# on this package we need to depend on the host version of ourselves to be able to run the ttl generator
STATEVARIABLEFILTER_DPF_DEPENDENCIES = host-StateVariableFilter-DPF

# LV2 bundles that this package generates (space separated list)
STATEVARIABLEFILTER_DPF_BUNDLES = d_statevariablefilter.lv2

# call make with the current arguments and path. "$(@D)" is the build directory.
STATEVARIABLEFILTER_DPF_HOST_MAKE   = $(HOST_MAKE_ENV)   $(HOST_CONFIGURE_OPTS)   $(MAKE) -C $(@D)
STATEVARIABLEFILTER_DPF_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)

# temp dir where we place the generated ttls
STATEVARIABLEFILTER_DPF_TMP_DIR = $(HOST_DIR)/tmp-StateVariableFilter-DPF


# build plugins in host to generate ttls
define HOST_STATEVARIABLEFILTER_DPF_BUILD_CMDS
	# build everything
	$(STATEVARIABLEFILTER_DPF_HOST_MAKE)

	# delete binaries
	rm $(@D)/bin/*.lv2/*.so

	# create temp dir
	rm -rf $(STATEVARIABLEFILTER_DPF_TMP_DIR)
	mkdir -p $(STATEVARIABLEFILTER_DPF_TMP_DIR)

	# copy the generated bundles without binaries to temp dir
	cp -r $(@D)/bin/*.lv2 $(STATEVARIABLEFILTER_DPF_TMP_DIR)
endef

# build plugins in target skipping ttl generation
define STATEVARIABLEFILTER_DPF_BUILD_CMDS
	# create dummy generator
	mkdir -p $(@D)/bin
	touch $(@D)/bin/lv2_ttl_generator
	chmod +x $(@D)/bin/lv2_ttl_generator

	# copy previously generated bundles
	cp -r $(STATEVARIABLEFILTER_DPF_TMP_DIR)/*.lv2 $(@D)/bin/

	# now build in target
	$(STATEVARIABLEFILTER_DPF_TARGET_MAKE)

	# cleanup
	rm $(@D)/bin/lv2_ttl_generator
	rm -r $(STATEVARIABLEFILTER_DPF_TMP_DIR)
endef

# install command
define STATEVARIABLEFILTER_DPF_INSTALL_TARGET_CMDS
	$(STATEVARIABLEFILTER_DPF_TARGET_MAKE) install DESTDIR=$(TARGET_DIR)
endef


# import everything else from the buildroot generic package
$(eval $(generic-package))
# import host version too
$(eval $(host-generic-package))
