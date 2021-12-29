function get_line(table::Table)
    setup = table.setup
    ln = ""
    for c in 1:length(setup.ids)
        width = setup.widths[c]
        values = table.current_values
        if isassigned(values, c)
            val = values[c]
            s_val = format_table_value(width, val)
        else
            s_val = "-"
        end
        padding = width - 2 - length(s_val)
        alignment = setup.alignments[c]    
        if alignment == :center
            ln *= repeat(" ", fld(padding, 2) + 1)
            ln *= s_val
            ln *= repeat(" ", cld(padding, 2) + 1)
        elseif alignment == :left
            ln *= " "
            ln *= s_val
            ln *= repeat(" ", padding + 1)
        elseif alignment == :right
            ln *= repeat(" ", padding + 1)
            ln *= s_val
            ln *= " "
        else
            @error "Only the alignments :left, :right and :center are defined. $alignment isn't defined."
        end
    end
    return ln
end

function fill_from_prev!(table::Table)
    for i in 1:length(table.current_values) 
        if !isassigned(table.current_values, i) || isnothing(table.current_values[i])
            table.current_values[i] = table.prev_values[i]
        end
    end
end

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

function print_line(table::Table; force=false)
    fill_from_prev!(table)
    
    shall_print_line(table; force) || return
    println(get_line(table))
    update_for_new_row(table)
    return
end