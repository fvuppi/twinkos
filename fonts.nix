{ pkgs, ... }:

{
    fonts = {
        packages = with pkgs; [
            ibm-plex
            font-awesome
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-emoji
            nerd-fonts.noto
            nerd-fonts.fira-code
        ];
    };
}
