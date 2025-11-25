const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .os_tag = .freestanding,
    });

    const evilbit_module = b.createModule(.{
        .root_source_file = b.path("src/evilbit.zig"),
        .target = target,
        .optimize = .ReleaseSmall,
        .code_model = .kernel,
        .strip = true,
    });

    const obj = b.addObject(.{
        .name = "evilbit",
        .root_module = evilbit_module,
    });

    obj.bundle_compiler_rt = false;
    obj.export_table = false;

    const artifact = b.addInstallArtifact(obj, .{
        .dest_dir = .{
            .override = .{
                .custom = "obj",
            },
        },
    });
    b.getInstallStep().dependOn(&artifact.step);
}
