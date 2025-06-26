default:
	@just --list

update:
	nix flake update

switch:
	git add --all
	sudo darwin-rebuild switch --flake .
