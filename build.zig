const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("CsvLine", .{
        .root_source_file = b.path("src/CsvLine.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/CsvLine.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);

    const benchmark_tests = b.addTest(.{
        .root_source_file = b.path("src/Benchmark.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_benchmark_tests = b.addRunArtifact(benchmark_tests);

    const benchmark_step = b.step("benchmark", "Run Benchmark");
    benchmark_step.dependOn(&run_benchmark_tests.step);
}
