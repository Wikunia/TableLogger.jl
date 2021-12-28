using TableLogger
using Documenter

DocMeta.setdocmeta!(TableLogger, :DocTestSetup, :(using TableLogger); recursive=true)

makedocs(;
    modules=[TableLogger],
    authors="Ole Kröger <o.kroeger@opensourc.es> and contributors",
    repo="https://github.com/Ole Kröger/TableLogger.jl/blob/{commit}{path}#{line}",
    sitename="TableLogger.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Ole Kröger.github.io/TableLogger.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Ole Kröger/TableLogger.jl",
    devbranch="main",
)
