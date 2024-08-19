const std = @import("std");
const CsvLine = @import("CsvLine.zig").CsvLine;

const hpa = std.heap.page_allocator;

pub const Bench = *const fn (std.mem.Allocator) anyerror!void;

fn bench(function: Bench, name: []const u8, runs: usize, iterations: usize, allocator: std.mem.Allocator) !void {
    std.debug.print("{s}:\n", .{name});
    var times: [5]u64 = undefined;

    var timer = try std.time.Timer.start();
    for (0..runs) |run| {
        for (0..iterations) |i| {
            _ = i;
            try function(allocator);
        }
        times[run] = timer.lap();
    }

    var sum: f64 = 0;
    for (times, 1..) |time, i| {
        std.debug.print("{d}: {d}\n", .{ i, @as(f64, @floatFromInt(time)) / 1000000.0 });
        sum += @floatFromInt(time);
    }
    std.debug.print("average: {d}\n\n", .{sum / @as(f64, @floatFromInt(runs)) / 1000000.0});
}

var csvLine: CsvLine = undefined;

fn threeFields(allocator: std.mem.Allocator) !void {
    _ = allocator;
    _ = try csvLine.parse("1,2,3");
}

test "three fields" {
    csvLine = try CsvLine.init(hpa, .{});
    defer csvLine.free();
    try bench(&threeFields, "three fields", 5, 1000000, hpa);
}
