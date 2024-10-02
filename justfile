default:
	@just --list

update:
	nix flake update

switch:
	git add --all
	darwin-rebuild switch --flake .
