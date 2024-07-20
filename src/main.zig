const std = @import("std");
const parseArgs = @import("./lib/parseArgs.zig");
const Grid = @import("./lib/models/grid.zig").Grid;

pub fn main() !void {
    const args = parseArgs.get();
    std.debug.print("Args: {}\n", .{args.n});
    const grid = try Grid.init(args.n);
    std.debug.print("Grid: {any}\n", .{grid.n});
    grid.print();
}
