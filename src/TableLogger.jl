module TableLogger

"""
    struct TableSetup

Stores information about the columns of the table by storing:
ids, names, widths and alignments
"""
struct TableSetup
    ids::Vector{Symbol}
    names::Vector{String}
    widths::Vector{Int}
    alignments::Vector{Symbol}
end

"""
    mutable struct Table

Stores the [`TableSetup`](@ref) as well as the current and previous values
"""
mutable struct Table
    setup::TableSetup
    current_values::Vector
    prev_values::Vector
end

include("utils.jl")
include("format.jl")
include("header.jl")
include("line.jl")

"""
    init_log_table(ids::Vector{Symbol}, names::Vector{String}, widths::Vector{Int}, alignments::Vector{Symbol})

Initialize the table structure with a vector of ids, names, widths and alignments.
"""
function init_log_table(ids::Vector{Symbol}, names::Vector{String}, widths::Vector{Int}, alignments::Vector{Symbol})
    @assert length(ids) == length(names)
    @assert length(ids) == length(widths)
    @assert length(ids) == length(alignments)
    current_values = Vector{Any}(undef, length(ids))
    prev_values = Vector{Any}(undef, length(ids))
    return Table(TableSetup(ids, names, widths, alignments), current_values, prev_values)
end


"""
    init_log_table(columns::NamedTuple...; width=20, alignment=:center)

Initialize the table structure by a list of information for each column.

## Example
```
table = init_log_table(
    (id=:open_nodes, name="#Open", width=30),
    (id=:closed_nodes, name="#Closed"),
)
```

Would create a table with two columns named `#Open` and `#Closed` and the width of `#Open` is `30`.
The default width of `20` is used for the closed nodes and both tables use the default alignment `:center`.

```
table = init_log_table(
    (id=:open_nodes, name="#Open", width=30),
    (id=:closed_nodes, name="#Closed");
    alignment = :left
)
```

In this case the default alignment is changed to `:left`.
"""
function init_log_table(columns::NamedTuple...; width=20, alignment=:center)
    ids = Vector{Symbol}()
    names = Vector{String}()
    widths = Vector{Int}()
    alignments = Vector{Symbol}() 
    for column in columns 
        push!(ids, column.id)
        push!(names, column.name)
        if haskey(column, :width)
            push!(widths, column.width)
        else
            push!(widths, width)
        end
        if haskey(column, :alignment)
            push!(alignments, column.alignment)
        else
            push!(alignments, alignment)
        end
    end
    return init_log_table(ids, names, widths, alignments)
end

export init_log_table, print_header, print_line, set_value!
end