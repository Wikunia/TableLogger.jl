"""
    get_column_id(table::Table, sym::Symbol)

Return the column id of the given symbol `sym`. 
If the symbol doesn't exist throw an error.
"""
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
    error("Column symbol: $sym doesn't exist")
end

"""
    set_value!(table::Table, column::Symbol, value)

Set the current value of the given `column` to `value`
"""
function set_value!(table::Table, column::Symbol, value)
    id = get_column_id(table, column)
    table.current_values[id] = value
end

"""
    update_for_new_row(table)

Set the previous values to `current_values` by using `deepcopy` and set all `current_values` to nothing.
"""
function update_for_new_row(table)
    table.prev_values = deepcopy(table.current_values)
    table.current_values .= nothing
end

"""
    differs_enough(value::T, prev_value::T) where T

Return true if the `value` is significantly different from `prev_value`.
In this default case simply return `true` if they are different. 
Provide your own `differs_enough` function by dispatching on both values.
"""
function differs_enough(value::T, prev_value::T) where T
    return value != prev_value
end

"""
    differs_enough(value::DiffX, prev_value::DiffX)

Check whether two [`DiffX`](@ref) values differ enough from each other.
"""
function differs_enough(value::DiffX, prev_value::DiffX)
    diff = abs(value.value - prev_value.value)
    return diff >= value.by    
end

"""
    Base.string(d::DiffX)

Taking the value of [`DiffX`](@ref) to represent it in the table.
"""
function Base.string(d::DiffX)
    return d.value
end
