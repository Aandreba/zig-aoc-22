const std = @import("std");
const alloc = std.heap.c_allocator;

const File = std.fs.File;
const Reader = File.Reader;

const NEW_LINE: u8 = 10;

pub fn main() anyerror!void {
    const cwd = std.fs.cwd();

    const file = try cwd.openFile("exercices/one.txt", File.OpenFlags{});
    defer file.close();

    var buf = try alloc.alloc(u8, (try file.stat()).size);
    defer alloc.free(buf);

    const reader = file.reader();

    var current_idx: usize = 0;
    var current_value: usize = 0;

    var idx: ?usize = null;
    var max: usize = 0;

    while (true) {
        const str = reader.readUntilDelimiter(buf, NEW_LINE) catch |err| {
            if (err == error.EndOfStream) {
                break;
            } else {
                return err;
            }
        };

        if (str.len == 0) {
            if (idx == null or max < current_value) {
                idx = current_idx;
                max = current_value;
            }
            current_idx += 1;
            current_value = 0;
            continue;
        }

        current_value += try std.fmt.parseUnsigned(usize, str, 10);
    }

    if (idx == null or max < current_value) {
        idx = current_idx;
        max = current_value;
    }

    std.debug.print("Max elf is {}, with {} calories\n", .{ idx, max });
}
