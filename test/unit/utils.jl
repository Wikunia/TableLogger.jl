@testset "get_column_id" begin
    table = init_log_table(
        (id=:open_nodes, name="#Open"),
        (id=:closed_nodes, name="#Closed"),
    )
    TableLogger.get_column_id(table, :closed_nodes) == 2
end