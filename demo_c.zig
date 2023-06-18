///
/// Contains the C version of the demo API. This is necessary because I want to
/// allow for passing libc FILE* into the demo reading API. This file provides
/// a small abstraction over FILE* and std.fs.File.
///
const std = @import("std");
const builtin = @import("builtin");

const fcntl_header = @cImport(.{@cInclude("fcntl.h")});
const stdio_header = @cImport(.{@cInclude("stdio.h")});
const fread = stdio_header.fread;
const fwrite = stdio_header.fwrite;
const fcntl = fcntl_header.fcntl;
const F_GETFD = fcntl_header.F_GETFD;

pub const std_options = struct {
    // log level depends on build mode
    pub const log_level = if (builtin.mode == .Debug) .debug else .info;
    // Define logFn to override the std implementation
    pub const logFn = @import("src/logging.zig").libdemo_logger;
};

///
/// Read from a given demo file and print the json to the given output file
/// descriptor.
///
pub fn demo_to_json(demo_file: *std.c.FILE, out: *std.c.FILE) callconv(.C) void {
    const demo_file_valid = fcntl(demo_file, F_GETFD);
    const out_file_valid = fcntl(out, F_GETFD);
    _ = demo_file_valid;
    _ = out_file_valid;
}
