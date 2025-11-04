{ config, pkgs, ... }:

{
	# nvidia configuration
	hardware.nvidia = {
		modesetting.enable = true;
		open = false;
		nvidiaSettings = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};

	# graphics support
	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};

	# video drivers
	services.xserver.videoDrivers = [ "nvidia" ];

	# audio
	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	# input devices
	services.libinput.enable = false;

	# bluetooth support
	hardware.bluetooth.enable = true;
}
