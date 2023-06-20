const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) !void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardOptimizeOption(.{});

    const lib = b.addSharedLibrary(.{
        .name = "demozig",
        .optimize = mode,
        .target = target,
        .root_source_file = std.Build.FileSource.relative("demo.zig"),
    });

    const c_lib = b.addSharedLibrary(.{
        .name = "demo",
        .optimize = mode,
        .target = target,
        .root_source_file = std.Build.FileSource.relative("demo.zig"),
    });

    // create the same option for each, one false and one true
    const build_options = b.addOptions();
    lib.addOptions("build-options", build_options);
    build_options.addOption(bool, "buildForC", false);

    const build_options_c = b.addOptions();
    c_lib.addOptions("build-options", build_options_c);
    build_options_c.addOption(bool, "buildForC", true);

    c_lib.linkLibC();

    b.installArtifact(lib);
    b.installArtifact(c_lib);
}
