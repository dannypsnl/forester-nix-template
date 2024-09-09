# forester-nix-template

This project is a starter template to have a new forest, it use `nix flake` to manage dependencies and provide basic commands

1. `build` render current `public-trees` and `private-trees`
2. `release` render `public-trees` to `deploy/output/`
3. `cleanup` remove `output/` and `deploy/output`

Before you start, you should modify configuration `./forest.toml`, `./deploy/forest.toml`, and `./public-trees/root.tree`, to use your customize data. Base on this project, trees in `private-trees` will not be rendered to `deploy/output`, so aware that `public-trees` is referring to a tree in `private-trees`, that will break `release` command.

## Update dependencies

You can go to [forester](https://git.sr.ht/~jonsterling/ocaml-forester) and [forest-server](https://github.com/kentookura/forest-server) for newer revision, I use hard-coded revision since forester is still in active development.
