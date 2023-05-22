const std = @import("std");
const alloc = std.heap.c_allocator;

const File = std.fs.File;
const Reader = File.Reader;

const NEW_LINE: u8 = 10;

const Entry = struct { elf: usize, calories: u64 };

pub fn getCalories() !std.ArrayList(Entry) {
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
            results.append(Entry{ .elf = current_idx, .calories = current_value });

            // Reset values
            current_idx += 1;
            current_value = 0;
            continue;
        }

        // Add calories to the current counter
        current_value += try std.fmt.parseUnsigned(usize, str, 10);
    }

    // Check last elf
    results.append(Entry{ .elf = current_idx, .calories = current_value });
    return results;
}

pub fn part_one() !void {
    const calories = try getCalories();
    defer calories.deinit();

    if (calories[0]) |entry| {
        std.debug.print("Max elf is {}, with {} calories\n", .{ entry.elf, entry.calories });
    } else {
        std.debug.print("No elf was found");
    }
    // Print result
}

pub fn part_two() anyerror!void {}
