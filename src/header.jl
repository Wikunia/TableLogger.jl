
"""
    get_header(table::Table)

Return the header string of the `Table` including `======` as the second line
"""
function get_header(table::Table)
    setup = table.setup
    ln = ""
    sum_width = 0
    for (name, width) in zip(setup.names, setup.widths)
        sum_width += width
        padding = width - 2 - length(name)
        if padding < 0
            error("The width must be at least 2+length(name) for each column")
        end
        ln *= repeat(" ", fld(padding, 2) + 1)
        ln *= name
        ln *= repeat(" ", cld(padding, 2) + 1)
    end
    equals = repeat("=", sum(sum_width))
    header = "$ln\n$equals"
    return header
end

"""
    print_header(table::Table)

Print the header of the given `table`. Calls [`get_header`](@ref).
"""
print_header(table::Table) = println(get_header(table))
