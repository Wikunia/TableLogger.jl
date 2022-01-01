"""
    get_line(table::Table)

Get the next line of the table by using `table.current_values`.
Call [`format_table_value`](@ref) to format each value and use the alignments to create the line such that it fits to [`get_header`](@ref).
"""
function get_line(table::Table)
    setup = table.setup
    ln = ""
    for c in 1:length(setup.ids)
        width = setup.widths[c]
        values = table.current_values
        default_precision = setup.precisions[c]
        if isassigned(values, c)
            val = values[c]
            s_val = format_table_value(width-2, get_value(val); default_precision)
        else
            s_val = "-"
        end
        padding = width - 2 - length(s_val)
        alignment = setup.alignments[c]    
        if alignment == :center
            left_padding = repeat(" ", fld(padding, 2) + 1)
            right_padding = repeat(" ", cld(padding, 2) + 1)
            ln = "$(ln)$(left_padding)$(s_val)$(right_padding)"
        elseif alignment == :left
            right_padding = repeat(" ", padding + 1)
            ln = "$(ln) $(s_val)$(right_padding)"
        elseif alignment == :right
            left_padding = repeat(" ", padding + 1)
            ln = "$(ln)$(left_padding)$(s_val) "
        else
            @error "Only the alignments :left, :right and :center are defined. $alignment isn't defined."
        end
    end
    return ln
end

"""
    fill_from_prev!(table::Table)

If a value isn't given by a new called [`set_value!`](@ref) since the last call to [`print_line`](@ref) the previous value will be used.
This function overwrites `table.current_values` to set unassigned values to `table.prev_values`.
"""
function fill_from_prev!(table::Table)
    for i in 1:length(table.current_values) 
        if !isassigned(table.current_values, i) || isnothing(table.current_values[i])
            table.current_values[i] = table.prev_values[i]
        end
    end
end

"""
    shall_print_line(table::Table; force=false)

Return whether the new line shall be printed. If `force = true` return true immediately.
Otherwise check if at least one value differs enough from the previous value by calling [`differs_enough`](@ref).
"""
function shall_print_line(table::Table; force=false)
    force && return true

    # check if a current value differs enough from the previous value
    shall_update = false
    for i in 1:length(table.current_values) 
        !isassigned(table.current_values, i) && continue
        value = table.current_values[i]
        if !isassigned(table.prev_values, i) || differs_enough(value, table.prev_values[i])
            shall_update = true
            break
        end
    end
    return shall_update
end

"""
    print_line(table::Table; force=false)

Print the new line of the table if it differs enough from the previous line or if `force = true`.
If the new line gets printed set the `prev_values` to `current_values` and the `current_values` to an `nothing`.
"""
function print_line(table::Table; force=false)
    fill_from_prev!(table)

    shall_print_line(table; force) || return
    println(get_line(table))
    update_for_new_row(table)
    return
end
