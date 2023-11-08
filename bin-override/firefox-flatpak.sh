#!/bin/sh

# org.mozilla.firefox from flathub
# ---
# @see https://flathub.org/setup/Fedora
# @see https://flathub.org/apps/org.mozilla.firefox
# ---
# Install instructions:
# ---
# flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# flatpak install flathub org.mozilla.firefox
# flatpak override --user --socket=wayland org.mozilla.firefox
# flatpak override --user --env MOZ_ENABLE_WAYLAND=1 org.mozilla.firefox
exec flatpak run org.mozilla.firefox "$@"
grep '^# ' <"$0" | cut -c3- 1>&2
exit 127
