// Kernel utilities

const std = @import("std");

extern fn zig_printk_info(msg: [*:0]const u8) void;
extern fn zig_printk_err(msg: [*:0]const u8) void;
extern fn zig_printk_warn(msg: [*:0]const u8) void;

pub fn print(comptime fmt: []const u8, args: anytype) void {
    var buf: [1024]u8 = undefined;
    const formatted = std.fmt.bufPrint(&buf, fmt, args) catch return;

    var null_terminated: [1025]u8 = undefined;
    @memcpy(null_terminated[0..formatted.len], formatted);
    null_terminated[formatted.len] = 0;

    zig_printk_info(@as([*:0]const u8, @ptrCast(&null_terminated)));
}

pub fn printErr(comptime fmt: []const u8, args: anytype) void {
    var buf: [1024]u8 = undefined;
    const formatted = std.fmt.bufPrint(&buf, fmt, args) catch return;

    var null_terminated: [1025]u8 = undefined;
    @memcpy(null_terminated[0..formatted.len], formatted);
    null_terminated[formatted.len] = 0;

    zig_printk_err(@as([*:0]const u8, @ptrCast(&null_terminated)));
}

pub fn printWarn(comptime fmt: []const u8, args: anytype) void {
    var buf: [1024]u8 = undefined;
    const formatted = std.fmt.bufPrint(&buf, fmt, args) catch return;

    var null_terminated: [1025]u8 = undefined;
    @memcpy(null_terminated[0..formatted.len], formatted);
    null_terminated[formatted.len] = 0;

    zig_printk_warn(@as([*:0]const u8, @ptrCast(&null_terminated)));
}
