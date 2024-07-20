const std = @import("std");

pub const Args = struct {
    n: u8,
};

fn showHelp() void {
    std.debug.print("Usage: program [options]\n", .{});
    std.debug.print("Options <type> [default]:\n", .{});
    std.debug.print("  --help | -h: Display this help message\n", .{});
    std.debug.print("  -v: Display the version\n", .{});
    std.debug.print("  -n <u8>: Size of grid to generate [9]\n", .{});
}

fn handleNArg(argsIter: *std.process.ArgIterator) u8 {
    const nullableN = argsIter.next();
    if (nullableN == null) {
        std.debug.print("Expected an argument after -n\n", .{});
        std.debug.print("\n", .{});
        showHelp();
        std.process.exit(1);
    }
    return std.fmt.parseInt(u8, nullableN.?, 10) catch |err| {
        std.debug.print("Error: {s}\n", .{@errorName(err)});
        std.debug.print("Failed to parse -n argument\n", .{});
        std.debug.print("Expected an integer from 0 to 255\n", .{});
        std.debug.print("\n", .{});
        showHelp();
        std.process.exit(1);
    };
}

pub fn get() Args {
    const alloc = std.heap.page_allocator;
    var argsIter = try std.process.ArgIterator.initWithAllocator(alloc);
    defer argsIter.deinit();

    _ = argsIter.next(); // skip the program name

    var args = Args{ .n = 9 };
    while (argsIter.next()) |arg| {
        if (std.mem.eql(u8, arg, "--help")) {
            showHelp();
            std.process.exit(0);
        } else if (std.mem.eql(u8, arg, "-h")) {
            showHelp();
            std.process.exit(0);
        } else if (std.mem.eql(u8, arg, "-v")) {
            std.debug.print("Version 0.1.0\n", .{});
            std.process.exit(0);
        } else if (std.mem.eql(u8, arg, "-n")) {
            args.n = handleNArg(&argsIter);
        } else {
            std.debug.print("Unknown argument: {s}\n", .{arg});
            std.debug.print("\n", .{});
            showHelp();
            std.process.exit(1);
        }
    }
    return args;
}
