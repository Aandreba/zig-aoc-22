const std = @import("std");

const File = std.fs.File;

const Play = enum {
    Rock,
    Paper,
    Scissors,

    fn score(self: Play) u8 {
        return switch (self) {
            .Rock => 1,
            .Paper => 2,
            .Scissors => 3,
        };
    }

    fn from_name(char: u8) ?Play {
        return switch (char) {
            'X', 'A' => .Rock,
            'Y', 'B' => .Paper,
            'Z', 'C' => .Scissors,
            else => null,
        };
    }

    fn battle(self: Play, other: Play) Result {
        if (self == other) return .Draw;

        switch (self) {
            .Rock => {
                if (other == .Paper) {
                    return .Loss;
                } else if (other == .Scissors) {
                    return .Win;
                } else {
                    unreachable;
                }
            },

            .Paper => {
                if (other == .Rock) {
                    return .Win;
                } else if (other == .Scissors) {
                    return .Loss;
                } else {
                    unreachable;
                }
            },

            .Scissors => {
                if (other == .Rock) {
                    return .Loss;
                } else if (other == .Paper) {
                    return .Win;
                } else {
                    unreachable;
                }
            },
        }
    }
};

const Result = enum {
    Win,
    Loss,
    Draw,

    fn score(self: Result) u8 {
        return switch (self) {
            .Win => 6,
            .Draw => 3,
            .Loss => 0,
        };
    }

    fn reverse(self: Result) Result {
        return switch (self) {
            .Win => .Loss,
            .Loss => .Win,
            .Draw => .Draw,
        };
    }
};

pub fn day2() anyerror!void {
    try part_one();
}

pub fn part_one() anyerror!void {
    const cwd = std.fs.cwd();

    // Open file handle
    const file = try cwd.openFile("exercices/two.txt", .{});
    defer file.close();

    var buffered = std.io.bufferedReader(file.reader());
    const reader = buffered.reader();

    var score: u64 = 0;
    while (true) {
        const opponent = Play.from_name(reader.readByte() catch |err| {
            if (err == error.EndOfStream) {
                break;
            } else {
                return err;
            }
        }) orelse unreachable;
        try reader.skipBytes(1, .{ .buf_size = 1 });
        const player = Play.from_name(try reader.readByte()) orelse unreachable;
        try reader.skipBytes(1, .{ .buf_size = 1 });

        const play_points = player.score();
        const battle_pts = player.battle(opponent).score();
        score += play_points + battle_pts;
    }

    std.debug.print("{}\n", .{score});
}
