{ config, pkgs, ... }:

{
	imports =
		[
			./hardware-configuration.nix
			./hardware.nix
			./fonts.nix	
		];
		
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "zolidepem";
	networking.networkmanager.enable = false;

	nix.settings.download-buffer-size = 524288000;
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	nixpkgs.config.allowUnfree = true;

	services.openssh.enable = true;

	users.users.nika = {
		shell = pkgs.zsh;
		isNormalUser = true;
		description = "nika";
		extraGroups = [ "wheel" "gamemode" ];
		packages = with pkgs; [
			(btop.override { cudaSupport = true; })
			bluetui
			discord
			obs-studio
			obs-studio-plugins.wlrobs
			alacritty
			wofi
			swww
			slurp
			grim
			waybar
			lf
			ffmpeg
			wf-recorder
			(callPackage ./pkgs/helium.nix {})
			cbonsai
		];
	};

	environment.systemPackages = with pkgs; [
		vim
		wget
		git
		zsh
	];

	programs.firefox.enable = true;
	programs.zsh.enable = true;
	programs.mtr.enable = true;
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
	};

	programs.sway = {
		enable = true;
		package = pkgs.swayfx;
		extraOptions = [ "--unsupported-gpu" ];
		wrapperFeatures.gtk = true;
	};

	xdg.portal = {
		enable = true;
		wlr.enable = true;
		extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	};

	programs.steam = {
		enable = true;
		remotePlay.openFirewall = false;
		dedicatedServer.openFirewall = false;
		gamescopeSession.enable = false;
	};

	programs.gamemode.enable = true;

	environment.sessionVariables = {
		WLR_NO_HARDWARE_CURSORS = "1";
		LIBVA_DRIVER_NAME = "nvidia";
		GBM_BACKEND = "nvidia-drm";
		__GLX_VENDOR_LIBRARY_NAME = "nvidia";

		NIXOS_OZONE_WL = "1";
		MOZ_ENABLE_WAYLAND = "1";

		XDG_SESSION_TYPE = "wayland";
		XDG_CURRENT_DESKTOP = "sway";
	};

	time.timeZone = "Asia/Jerusalem";
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "en_US.UTF-8";
		LC_IDENTIFICATION = "en_US.UTF-8";
		LC_MEASUREMENT = "en_US.UTF-8";
		LC_MONETARY = "en_US.UTF-8";
		LC_NAME = "en_US.UTF-8";
		LC_NUMERIC = "en_US.UTF-8";
		LC_PAPER = "en_US.UTF-8";
		LC_TELEPHONE = "en_US.UTF-8";
		LC_TIME = "en_US.UTF-8";
	};

	services.xserver.xkb = {
		layout = "us";
		variant = "";
	};

	systemd.user.services.sway-session-target = {
		description = "sway session target";
		wantedBy = [ "default.target" ];
		serviceConfig = {
			Type = "oneshot";
			RemainAfterExit = true;
			ExecStart = "${pkgs.coreutils}/bin/true";
		};
	};

	fileSystems."/mnt/media" = {
		device = "/dev/disk/by-label/MEDIA";
		fsType = "xfs";
		options = [ "defaults" ];
	};

	fileSystems."/mnt/games" = {
		device = "/dev/disk/by-label/GAMES";
		fsType = "xfs";
		options = [ "defaults" ];
	};

	system.stateVersion = "25.05";
}
