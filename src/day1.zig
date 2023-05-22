const std = @import("std");
const alloc = std.heap.c_allocator;
const math = std.math;

const File = std.fs.File;
const Reader = File.Reader;

const NEW_LINE: u8 = 10;

const Entry = struct { elf: usize, calories: u64 };

pub fn day1() anyerror!void {
    try part_one();
    try part_two();
}

pub fn part_one() anyerror!void {
    const calories = try get_calories();
    defer calories.deinit();

    if (calories.items.len == 0) {
        std.debug.print("No elf was found", .{});
    } else {
        const entry = calories.items[0];
        std.debug.print("Max elf is {?}, with {} calories\n", .{ entry.elf, entry.calories });
    }
}

pub fn part_two() anyerror!void {
    const calories = try get_calories();
    defer calories.deinit();

    var total: u64 = 0;
    for (calories.items[0..3]) |entry| {
        total += entry.calories;
    }

    std.debug.print("Top 3 elfs have {} calories\n", .{total});
}

fn get_calories() anyerror!std.ArrayList(Entry) {
    const cwd = std.fs.cwd();

    // Open file handle
    const file = try cwd.openFile("exercices/one.txt", File.OpenFlags{});
    defer file.close();

    // Allocate buffer to read lines
    var buf = try alloc.alloc(u8, (try file.stat()).size);
    defer alloc.free(buf);

    // Open reader
    const reader = file.reader();
    var results = std.ArrayList(Entry).init(alloc);

    var current_idx: usize = 0;
    var current_value: usize = 0;

    while (true) {
        // Read next line
        const str = reader.readUntilDelimiter(buf, NEW_LINE) catch |err| {
            // If we reached EOF, stop iterating
            if (err == error.EndOfStream) {
                break;
            } else {
                // THrow any other errors
                return err;
            }
        };

        // If line is empty, we're done with this elf
        if (str.len == 0) {
            const idx = binary_search(results.items, current_value);
            try results.insert(idx, Entry{ .elf = current_idx, .calories = current_value });

            // Reset values
            current_idx += 1;
            current_value = 0;
            continue;
        }

        // Add calories to the current counter
        current_value += try std.fmt.parseUnsigned(usize, str, 10);
    }

    // Check last elf
    const idx = binary_search(results.items, current_value);
    try results.insert(idx, Entry{ .elf = current_idx, .calories = current_value });
    return results;
}

fn binary_search(items: []const Entry, value: u64) usize {
    var left: usize = 0;
    var right: usize = items.len;

    while (left < right) {
        // Avoid overflowing in the midpoint calculation

        const mid = left + (right - left) / 2;
        // Compare the key with the midpoint element

        switch (math.order(value, items[mid].calories)) {
            .eq => return mid,
            .gt => right = mid,
            .lt => left = mid + 1,
        }
    }

    return left;
}
