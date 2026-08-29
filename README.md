# WorkbenchKit

Reusable macOS workbench chrome for the Hypermedia products: editor bar family
(path, title, controls, history), history rows / avatar / detail popover, split
chassis with collapse math, filter and selector bars, workbench column chrome,
inspector empty state, hash text, scheme pill, progress.

Repo: `hypermedia-tech/swift-workbench-kit`. Package and product name: `WorkbenchKit`.

## The law

**Domain-free, forever.** This package depends on nothing and imports no
product's Domain. Components speak in primitives, closures, and their own small
value types, so the same chrome serves forensic analysis rows, git commit rows,
story snapshot rows — any tenant. A Domain type appearing in this package's
signatures is a defect, not a convenience.

MainActor-isolated by default (SE-0466, declared in the manifest), macOS 26,
Swift 6.2.

## Consumers

CyberBench and CyberReport (TanukiPlatform), TotalRecall v2 — all by **URL +
version** (`https://github.com/hypermedia-tech/swift-workbench-kit`, Up to Next
Minor). No path references, ever: they break pipeline builds and lock shared
local packages to one open Xcode workspace.

**Editing:** use Xcode's local override — add this checkout as a local package
to the ONE project you're driving the edit from; it overrides the remote while
present. Remove it when done, commit here, tag the next version, push tags, and
bump consumers when they want it.

## Tests

`make test` (runs `swift test`). The suite also has a shared scheme + test plan
so Cmd-U works when the package is opened in Xcode. Consumers do not run this
suite — it runs here.
