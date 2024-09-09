# forester-nix-template

This project is a starter template to have a new forest, it uses `nix flake` to manage dependencies. Before you start, you should modify configuration `./forest.toml`, `./deploy/forest.toml`, and `./public-trees/root.tree`, to use your customize data. Base on this project, trees in `private-trees` will not be rendered to `deploy/output`, so aware if `public-trees` is referring to a tree in `private-trees` will break `release` command.

## Build commands

I recommend using `direnv` and `cat "use flake" > .envrc` and enable it, so you can use below commands

1. `build` render current `public-trees` and `private-trees`
2. `release` render `public-trees` to `deploy/output/`
3. `cleanup` remove `output/` and `deploy/output`

## Update dependencies

You can go to [forester](https://git.sr.ht/~jonsterling/ocaml-forester) and [forest-server](https://github.com/kentookura/forest-server) for newer revision, I use hard-coded revision since forester is still in active development.

## LaTeX stuff

Usual forester macros are put in `public-trees/base-macros.tree`
```
\alloc\base/tex-preamble

\def\texfig[~body]{
 \scope{
  \put?\base/tex-preamble{
   \latex-preamble/string-diagrams
   \latex-preamble/diagrams
  }
  % Wrap the diagram in a figure
  \figure{
   % Render the LaTeX code with the current preamble
   \tex{\get\base/tex-preamble}{\body{}}
  }
 }
}
```

So you can use them

```
\import{base-macros}

\texfig{
\begin{tikzpicture}[scale=0.5]
  % Coordinate layout and vertex positioning
  \path coordinate[] (mid)
  +(0,1) coordinate[label=above:$F$] (F)
  +(0.5,1) coordinate[label=above:$x$] (a_top)
  +(0,0) coordinate[label=below:$\alpha$, circle, draw=black, fill=black, minimum size=1mm, inner sep=0mm] (alpha)
  +(-0.5,-1) coordinate[label=below:$x$] (a_bot)
  (a_top) ++ (0.5,0) coordinate (topright)
  (a_bot) ++ (1.5,0) coordinate (botright)
  (a_top) ++ (-1.5,0) coordinate (topleft)
  (a_bot) ++ (-0.5,0) coordinate (botleft);
  % Line drawing
  \draw[spath/save=midline] (a_top) to[out=-90, in=30] (mid) to[out=-150, in=90] (a_bot);
  \draw (F) -- (alpha);
  % Region filling
  \begin{scope}[on background layer]
    \fill[gray!50, spath/use=midline] -- (botright) -- (topright) -- (a_top) -- cycle;
    \fill[yellow!50, spath/use=midline] -- (botleft) -- (topleft) -- (a_top) -- cycle;
  \end{scope}
\end{tikzpicture}
}
```

<img width="685" alt="image" src="https://github.com/user-attachments/assets/c6ed36d8-e27c-45cc-9fde-f9df0a2d4605">
