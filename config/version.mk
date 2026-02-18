PRODUCT_VERSION_MAJOR = 16
PRODUCT_VERSION_MINOR = 0

# Increase Carbon Version with each major release.
CARBON_VERSION_DISPLAY := 
CARBON_FLAVOR := 
CARBON_VERSION_BASE := 
CARBON_CODENAME := 
CARBON_BUILD_TYPE ?= Unofficial

CARBON_BUILD_DATE := $(shell date -u +%Y%m%d)

CURRENT_DEVICE := $(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
OFFICIAL_MAINTAINERS := $(shell cat carbon-maintainers/carbon.maintainers)
OFFICIAL_DEVICES := $(shell cat carbon-maintainers/carbon.devices)

ifeq ($(findstring $(LINEAGE_BUILD), $(OFFICIAL_DEVICES)),)
  # Device not listed as official
  CARBON_BUILD_TYPE := UNOFFICIAL
else
  # Check if builder is an official maintainer
  ifeq ($(findstring $(CARBONOS_MAINTAINER), $(OFFICIAL_MAINTAINERS)),)
    # Builder not an official maintainer, warn and set unofficial
    $(warning **********************************************************************)
    $(warning *   There is already an official maintainer for $(LINEAGE_BUILD)    *)
    $(warning *              Setting build type to UNOFFICIAL                      *)
    $(warning **********************************************************************)
    CARBON_BUILD_TYPE := UNOFFICIAL
  else
    # Official maintainer building official device
    CARBON_BUILD_TYPE := OFFICIAL
  endif
endif

# Enforce official build for official maintainers on official devices
ifeq ($(CARBON_BUILD_TYPE), OFFICIAL)
  ifeq ($(findstring $(LINEAGE_BUILD), $(OFFICIAL_DEVICES)),)
    # Shouldn't reach here, error for unexpected situation
    $(error **********************************************************)
    $(error *     A violation has been detected, aborting build      *)
    $(error **********************************************************)
  endif
endif


# Carbon Packages
#ifeq ($(WITH_GMS),true)
#  ifeq ($(TARGET_USES_MINI_GAPPS), true)
#    CARBON_PACKAGE_TYPE ?= MINI
#  else ifeq ($(TARGET_USES_PICO_GAPPS), true)
#    CARBON_PACKAGE_TYPE ?= PICO
#  else
#    CARBON_PACKAGE_TYPE ?= GAPPS
#  endif
#else
#  CARBON_PACKAGE_TYPE ?= VANILLA
#endif

# Internal version
LINEAGE_VERSION := CarbonOS-$(CARBON_VERSION_BASE)-$(CARBON_CODENAME)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(CARBON_PACKAGE_TYPE)-$(shell date +%Y%m%d-%H%M)-$(LINEAGE_BUILD)-$(CARBON_BUILD_TYPE)

# Display version
LINEAGE_DISPLAY_VERSION := CarbonOS-$(CARBON_VERSION_BASE)-$(CARBON_CODENAME)-$(CARBON_PACKAGE_TYPE)-$(LINEAGE_BUILD)-$(CARBON_BUILD_TYPE)-$(shell date +%Y%m%d-%H%M)

# LineageOS version properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.carbon.version=$(LINEAGE_VERSION) \
    ro.carbon.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.carbon.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.modversion=$(CARBON_VERSION) \
    ro.carbon.packagetype=$(CARBON_PACKAGE_TYPE) \
    ro.carbon.version_display=$(CARBON_VERSION_DISPLAY) \
    ro.carbon.version.base=$(CARBON_VERSION_BASE) \
    ro.carbonos.maintainer=$(CARBONOS_MAINTAINER) \
    ro.carbonos.flavor=$(CARBON_FLAVOR) \
    ro.carbon.codename=$(CARBON_CODENAME) \
    ro.carbon.buildtype=$(CARBON_BUILD_TYPE)
