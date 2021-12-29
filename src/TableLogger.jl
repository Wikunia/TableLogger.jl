module TableLogger

struct TableSetup
    ids::Vector{Symbol}
    names::Vector{String}
    widths::Vector{Int}
    alignments::Vector{Symbol}
end

struct DiffX{V,B}
    by::B
    value::V
end

function DiffX(by)
    return (val)->DiffX(by, val)
end

const Diff5 = DiffX(5)
const Diff10 = DiffX(10)

mutable struct Table
    setup::TableSetup
    current_values::Vector
    prev_values::Vector
end

include("utils.jl")
include("format.jl")
include("header.jl")
include("line.jl")

function init_log_table(ids::Vector{Symbol}, names::Vector{String}, widths::Vector{Int}, alignments::Vector{Symbol})
    @assert length(ids) == length(names)
    @assert length(ids) == length(widths)
    @assert length(ids) == length(alignments)
    current_values = Vector{Any}(undef, length(ids))
    prev_values = Vector{Any}(undef, length(ids))
    return Table(TableSetup(ids, names, widths, alignments), current_values, prev_values)
end

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
export DiffX, Diff5, Diff10
end
