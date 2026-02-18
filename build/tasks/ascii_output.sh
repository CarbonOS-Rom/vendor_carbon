#!/bin/bash
# CarbonOS Build Output Banner
# Arguments:
# 1=device, 2=rom_name, 3=carbon_version, 4=package_type,
# 5=release_type, 6=zip_path, 7=maintainer, 8=build_duration_seconds

DEVICE="$1"
ROM_NAME="$2"
VERSION="$3"
PACKAGE_TYPE="$4"
RELEASE_TYPE="$5"
ZIP_PATH="$6"
MAINTAINER="$7"
BUILD_DURATION="$8"

# Fallbacks
[ -z "$MAINTAINER" ] && MAINTAINER="Unknown"
[ -z "$BUILD_DURATION" ] && BUILD_DURATION=0

# ─────────────────────────────────────────────
# Colors (black & white with CarbonOS teal)
# ─────────────────────────────────────────────
WHITE="\e[1;97m"
GREY="\e[38;5;245m"
DARK="\e[38;5;238m"
TEAL="\e[1;38;5;43m"
GREEN="\e[1;32m"
RED="\e[1;31m"
BOLD="\e[1m"
RESET="\e[0m"

# ─────────────────────────────────────────────
# Release Type Color
# ─────────────────────────────────────────────
case "$(echo "$RELEASE_TYPE" | tr '[:upper:]' '[:lower:]')" in
    official)   RELEASE_COLOR="$GREEN" ;;
    unofficial) RELEASE_COLOR="$RED" ;;
    *)          RELEASE_COLOR="$WHITE" ;;
esac

# File size
if [ -f "$ZIP_PATH" ]; then
    FILE_SIZE=$(du -h "$ZIP_PATH" | awk '{print $1}')
else
    FILE_SIZE="N/A"
fi

# ─────────────────────────────────────────────
# Build duration (seconds → h/m/s)
# ─────────────────────────────────────────────
HOURS=$((BUILD_DURATION / 3600))
MINS=$(((BUILD_DURATION % 3600) / 60))
SECS=$((BUILD_DURATION % 60))

if [ "$HOURS" -gt 0 ]; then
    DURATION_FORMAT="${HOURS}h ${MINS}m ${SECS}s"
elif [ "$MINS" -gt 0 ]; then
    DURATION_FORMAT="${MINS}m ${SECS}s"
else
    DURATION_FORMAT="${SECS}s"
fi

# ─────────────────────────────────────────────
# ASCII Banner
# ─────────────────────────────────────────────
LINE="${DARK}────────────────────────────────────────────────────────────────────────${RESET}"

echo ""
echo -e "$LINE"
echo ""
echo -e "   ${WHITE} ██████╗ █████╗ ██████╗ ██████╗  ██████╗ ███╗   ██╗${TEAL}  ██████╗ ███████╗${RESET}"
echo -e "   ${WHITE}██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔═══██╗████╗  ██║${TEAL} ██╔═══██╗██╔════╝${RESET}"
echo -e "   ${WHITE}██║     ███████║██████╔╝██████╔╝██║   ██║██╔██╗ ██║${TEAL} ██║   ██║███████╗${RESET}"
echo -e "   ${WHITE}██║     ██╔══██║██╔══██╗██╔══██╗██║   ██║██║╚██╗██║${TEAL} ██║   ██║╚════██║${RESET}"
echo -e "   ${WHITE}╚██████╗██║  ██║██║  ██║██████╔╝╚██████╔╝██║ ╚████║${TEAL} ╚██████╔╝███████║${RESET}"
echo -e "   ${GREY} ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═══╝${GREY}  ╚═════╝ ╚══════╝${RESET}"
echo ""
echo -e "$LINE"

# ─────────────────────────────────────────────
# Build Summary Box (auto-sized, borders line up)
# ─────────────────────────────────────────────
LABELS=("ROM Name" "Zip File" "Version" "Package Type" "Release Type" "Device" "Maintainer" "File Size" "Build Time")
VALUES=("$ROM_NAME" "$(basename "$ZIP_PATH")" "$VERSION" "$PACKAGE_TYPE" "$RELEASE_TYPE" "$DEVICE" "$MAINTAINER" "$FILE_SIZE" "$DURATION_FORMAT")

TITLE="CarbonOS Build Summary"
LABEL_W=14
VAL_W=${#TITLE}
for v in "${VALUES[@]}"; do
    [ ${#v} -gt $VAL_W ] && VAL_W=${#v}
done
INNER=$((LABEL_W + VAL_W + 3))
BAR=$(printf '─%.0s' $(seq 1 "$INNER"))

echo ""
echo -e "${GREY}╭${BAR}╮${RESET}"
printf "${GREY}│${RESET} ${TEAL}%-*s${RESET} ${GREY}│${RESET}\n" $((INNER - 2)) "$TITLE"
echo -e "${GREY}├${BAR}┤${RESET}"
for i in "${!LABELS[@]}"; do
    COLOR="$WHITE"
    [ "${LABELS[$i]}" = "Release Type" ] && COLOR="$RELEASE_COLOR"
    printf "${GREY}│${RESET} ${BOLD}%-*s${RESET} ${COLOR}%-*s${RESET} ${GREY}│${RESET}\n" \
        "$LABEL_W" "${LABELS[$i]}" "$VAL_W" "${VALUES[$i]}"
done
echo -e "${GREY}╰${BAR}╯${RESET}"
echo ""
echo -e "${TEAL}⬢${RESET} ${WHITE}Build completed successfully!${RESET}"
echo -e "${GREY}  Output: ${ZIP_PATH}${RESET}"
echo ""