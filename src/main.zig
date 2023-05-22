const std = @import("std");
const day1 = @import("day1.zig");

pub fn main() anyerror!void {
    try day1.part_one();
    try day1.part_two();
}
