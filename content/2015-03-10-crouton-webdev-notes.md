# 2015-03-10 -- ChromeOS/Crouton WebDev Notes

[Crouton]() makes it quite easy to setup an ubuntu chroot within ChromeOS.
Depending on what you're doing, various tweaks to the usual way of doing things may be needed.

Issues I experienced, and resolutions, if any:

Using a USB3 drive or SIM card for supplemental storage:
By default `/dev/sda1` was mounted with data-only options, including `noexec`.
This mount setup caused strange errors "failed to map segment from shared object, operation not permitted".
To resolve, `/dev/sda1` should be explicitly mounted in `/etc/fstab` with options that grant `exec`.
[reference](http://www.quakelive.com/forum/showthread.php?4208-LINUX-failed-to-map-segment-from-shared-object-Operation-not-permitted)

Using `i3wm`, create `~/.xinitrc` with the content `exec i3`. To enter the env,
just enter crosh (`Alt-t`), enter bash `shell`, go into your chroot,
`sudo enter-chroot`, and finally run `xinit` to bring up the `i3` env.

