const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    const filename = args[1];

    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    const contents = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(contents);

    var lines = std.mem.splitScalar(u8, contents, '\n');

    var l1 = std.ArrayList(i32).init(allocator);
    defer l1.deinit();

    var l2 = std.ArrayList(i32).init(allocator);
    defer l2.deinit();

    var store = std.AutoHashMap(i32, i32).init(allocator);
    defer store.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        const trimmed_line = std.mem.trim(u8, line, &[_]u8{13});
        if (trimmed_line.len == 0) continue;

        var parts = std.mem.tokenizeAny(u8, trimmed_line, " \t");

        const value1 = try std.fmt.parseInt(i32, parts.next().?, 10);
        const value2 = try std.fmt.parseInt(i32, parts.next().?, 10);

        try l1.append(value1);
        try l2.append(value2);

        const value2_count = store.get(value2);
        if (value2_count == null) {
            try store.put(value2, 1);
        } else {
            try store.put(value2, value2_count.? + 1);
        }
    }

    std.mem.sort(i32, l1.items, l1.capacity, compByValue);
    std.mem.sort(i32, l2.items, l2.capacity, compByValue);

    var result: u32 = 0;
    for (l1.items, l2.items) |a, b| {
        const distance = @abs(a - b);
        result += distance;
    }
    std.debug.print("Part1 Result: {d}\n", .{result});

    var result2: i32 = 0;
    for (l1.items) |a| {
        const value2_count = store.get(a);
        if (value2_count == null) {
            continue;
        }
        result2 += value2_count.? * a;
    }
    std.debug.print("Part2 Result: {d}\n", .{result2});
}

fn compByValue(_: usize, a: i32, b: i32) bool {
    return a < b;
}
