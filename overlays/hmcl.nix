self: super: {
	hmcl = super.hmcl.overrideAttrs (oldAttrs: rec {
		version = "3.8.0.306";
		
		src = super.fetchurl {
			url = "https://github.com/HMCL-dev/HMCL/releases/download/v${version}/HMCL-${version}.jar";
			sha256 = "sha256-MArbLqScpCN0OMmyEtN5xwW9PAxHINLDT3i5wjezOeU=";
		};
	});
}
