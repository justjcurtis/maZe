//grid.zig
const std = @import("std");

pub const Grid = struct {
    n: u8,
    data: [][]bool,
    pub fn init(n: u8) !Grid {
        var prng = std.rand.DefaultPrng.init(blk: {
            var seed: u64 = undefined;
            try std.posix.getrandom(std.mem.asBytes(&seed));
            break :blk seed;
        });
        const rand = prng.random();
        const allocator = std.heap.page_allocator;
        var data: [][]bool = undefined;
        data = try allocator.alloc([]bool, n);
        for (data) |*row| {
            row.* = try allocator.alloc(bool, n);
            for (row.*) |*cell| {
                cell.* = rand.intRangeAtMost(u8, 0, 2) == 1;
            }
        }
        return Grid{
            .n = n,
            .data = data,
        };
    }
    pub fn flip(self: Grid, x: u8, y: u8) void {
        self.data[x][y] = !self.data[x][y];
    }
    pub fn get(self: Grid, x: u8, y: u8) bool {
        return self.data[x][y];
    }
    pub fn set(self: Grid, x: u8, y: u8, value: bool) void {
        self.data[x][y] = value;
    }
    pub fn print(self: Grid) void {
        std.debug.print("┌", .{});
        for (0..self.n * 2 + 1) |_| {
            std.debug.print("─", .{});
        }
        std.debug.print("┐\n", .{});
        for (self.data) |*row| {
            std.debug.print("│ ", .{});
            for (row.*) |cell| {
                if (cell) {
                    std.debug.print("X ", .{});
                } else {
                    std.debug.print(". ", .{});
                }
            }
            std.debug.print("│\n", .{});
        }
        std.debug.print("└", .{});
        for (0..self.n * 2 + 1) |_| {
            std.debug.print("─", .{});
        }
        std.debug.print("┘\n", .{});
    }
};
