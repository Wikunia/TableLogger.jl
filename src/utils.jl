function get_column_id(table::Table, sym::Symbol)
    setup = table.setup
    ids = setup.ids
    for i in 1:length(ids)
        column_id = ids[i]
        if column_id == sym
            return i
            break
        end
    end
    @error "Column symbol: $sym doesn't exist"
end

function set_value!(table::Table, column::Symbol, value::T) where T
    id = get_column_id(table, column)
    table.current_values[id] = value
end

function update_for_new_row(table)
    table.prev_values = deepcopy(table.current_values)
    table.current_values .= nothing
end

function differs_enough(value::T, prev_value::T) where T
    return value != prev_value
end

function differs_enough(value::DiffX, prev_value::DiffX)
    diff = abs(value.value - prev_value.value)
    return diff >= value.by    
end

function Base.string(d::DiffX)
    return d.value
end
