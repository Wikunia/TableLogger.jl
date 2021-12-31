@testset  "Header" begin
    table = init_log_table(
        (id=:open_nodes, name="#Open"),
        (id=:closed_nodes, name="#Closed"),
    )
    header = TableLogger.get_header(table)
    lines = split(header, "\n")
    @test length(lines) == 2
    @test occursin("#Open", lines[1])
    @test occursin("#Closed", lines[1])
    @test length(lines[2]) == sum(table.setup.widths)
end
