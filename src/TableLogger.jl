module TableLogger

using Formatting

"""
    struct TableSetup

Stores information about the columns of the table by storing:
ids, names, widths, alignments and precision
"""
struct TableSetup
    ids::Vector{Symbol}
    names::Vector{String}
    widths::Vector{Int}
    alignments::Vector{Symbol}
    precisions::Vector{Int}
end

"""
    DiffX{V,B}

Can be used to specify the absolute difference which makes the given value different enough 
from the previous value to print a new line.
As an example if the last value is `DiffX(5, 10)` and the new value is `DiffX(5, 12)` the change is not significant enough.
If the next value however is `DiffX(5, 15)` then the value is different enough from the last printed value `10`.
Therefore a new line is printed.
"""
struct DiffX{V,B}
    by::B
    value::V
end

"""
    DiffX(by)

Create an anonymous function with something like `Diffd1 = DiffX(0.1)` to be able to use `Diffd1(10.0)` instead of `DiffX(0.1, 10.0)`.
"""
function DiffX(by)
    return (val)->DiffX(by, val)
end

const Diff5 = DiffX(5)
const Diff10 = DiffX(10)

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
    init_log_table(ids::Vector{Symbol}, names::Vector{String}, widths::Vector{Int}, alignments::Vector{Symbol}, precisions::Vector{Int})

Initialize the table structure with a vector of ids, names, widths, alignments and precisions.
"""
function init_log_table(ids::Vector{Symbol}, names::Vector{String}, widths::Vector{Int}, alignments::Vector{Symbol}, precisions::Vector{Int})
    @assert length(ids) == length(names)
    @assert length(ids) == length(widths)
    @assert length(ids) == length(alignments)
    @assert length(ids) == length(precisions)
    current_values = Vector{Any}(undef, length(ids))
    prev_values = Vector{Any}(undef, length(ids))
    return Table(TableSetup(ids, names, widths, alignments, precisions), current_values, prev_values)
end


"""
    init_log_table(columns::NamedTuple...; width=20, alignment=:center, precision=2)

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
function init_log_table(columns::NamedTuple...; width=20, alignment=:center, precision=2)
    ids = Vector{Symbol}()
    names = Vector{String}()
    widths = Vector{Int}()
    alignments = Vector{Symbol}() 
    precisions = Vector{Int}() 
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
        if haskey(column, :precision)
            push!(precisions, column.precision)
        else
            push!(precisions, precision)
        end
    end
    return init_log_table(ids, names, widths, alignments, precisions)
end

export init_log_table, print_header, print_line, set_value!
export DiffX, Diff5, Diff10
end
