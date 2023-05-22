const Play = enum {
    Rock,
    Paper,
    Scissors,

    fn battle(self: Play, other: Play) Result {
        if (self == other) return;
        
        switch (self) {
            .Rock => {
                if (other == .Paper)
            }
        }
    }
};

const Result = enum {
    Win,
    Loss,
    Draw,

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
    const lhs = Play.Paper;
    const rhs = Play.Scissors;
    _ = lhs.battle(rhs);
}
