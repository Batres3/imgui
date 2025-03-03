const std = @import("std");
const Compile = std.Build.Step.Compile;
const Target = std.Build.ResolvedTarget;
const Optimize = std.builtin.OptimizeMode;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "imgui",
        .target = target,
        .optimize = optimize,
    });
    // Zig gets confused when you give it cpp and .h files at the same time
    // const files_h = [_][]const u8{
    //     "imconfig.h",
    //     "imgui.h",
    //     "imgui_internal.h",
    //     "imstb_rectpack.h",
    //     "imstb_textedit.h",
    //     "imstb_truetype.h",
    // };
    const files_cpp = [_][]const u8{
        "imgui.cpp",
        "imgui_draw.cpp",
        "imgui_tables.cpp",
        "imgui_widgets.cpp",
        "imgui_demo.cpp",
    };

    lib.addCSourceFiles(.{
        .files = &files_cpp,
        .flags = &.{"-std=c++17"},
    });

    // Link the Cpp standard library
    lib.linkLibCpp();
    lib.addIncludePath(b.path("."));
    b.installArtifact(lib);
}
