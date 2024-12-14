const ChainedStruct = @import("chained_struct.zig").ChainedStruct;
const CommandBuffer = @import("command_encoder.zig").CommandBuffer;
const Buffer = @import("buffer.zig").Buffer;

const _texture = @import("texture.zig");
const ImageCopyTexture = _texture.ImageCopyTexture;
const TextureDataLayout = _texture.TextureDataLayout;
const Extent3D = _texture.Extent3D;

pub const SubmissionIndex = u64;
pub const WrappedSubmissionIndex = extern struct {
    queue: *Queue,
    submission_index: SubmissionIndex,
};

pub const QueueDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
};

pub const WorkDoneStatus = enum(u32) {
    success = 0x00000000,
    @"error" = 0x00000001,
    unknown = 0x00000002,
    device_lost = 0x00000003,
};

pub const WorkDoneCallback = *const fn (status: WorkDoneStatus, userdata: ?*anyopaque) callconv(.C) void;

pub const QueueProcs = struct {
    pub const OnSubmittedWorkDone = *const fn (*Queue, WorkDoneCallback, ?*anyopaque) callconv(.C) void;
    pub const SetLabel = *const fn (*Queue, ?[*:0]const u8) callconv(.C) void;
    pub const Submit = *const fn (*Queue, usize, [*]const *const CommandBuffer) callconv(.C) void;
    pub const WriteBuffer = *const fn (*Queue, Buffer, u64, *const anyopaque, usize) callconv(.C) void;
    pub const WriteTexture = *const fn (*Queue, *const ImageCopyTexture, *const anyopaque, usize, *const TextureDataLayout, *const Extent3D) callconv(.C) void;
    pub const Reference = *const fn (*Queue) callconv(.C) void;
    pub const Release = *const fn (*Queue) callconv(.C) void;

    // wgpu-native procs?
    // pub const SubmitForIndex = *const fn(*Queue, usize, [*]const *const CommandBuffer) callconv(.C) SubmissionIndex;
};

extern fn wgpuQueueOnSubmittedWorkDone(queue: *Queue, callback: WorkDoneCallback, userdata: ?*anyopaque) void;
extern fn wgpuQueueSetLabel(queue: *Queue, label: ?[*:0]const u8) void;
extern fn wgpuQueueSubmit(queue: *Queue, command_count: usize, commands: [*]const *const CommandBuffer) void;
extern fn wgpuQueueWriteBuffer(queue: *Queue, buffer: *Buffer, buffer_offset: u64, data: *const anyopaque, size: usize) void;
extern fn wgpuQueueWriteTexture(queue: *Queue, destination: *const ImageCopyTexture, data: *const anyopaque, data_size: usize, data_layout: *const TextureDataLayout, write_size: *const Extent3D) void;
extern fn wgpuQueueReference(queue: *Queue) void;
extern fn wgpuQueueRelease(queue: *Queue) void;

// wgpu-native
extern fn wgpuQueueSubmitForIndex(queue: *Queue, command_count: usize, commands: [*]const *const CommandBuffer) SubmissionIndex;

pub const Queue = opaque {
    pub inline fn onSubmittedWorkDone(self: *Queue, callback: WorkDoneCallback, userdata: ?*anyopaque) void {
        wgpuQueueOnSubmittedWorkDone(self, callback, userdata);
    }
    pub inline fn setLabel(self: *Queue, label: ?[*:0]const u8) void {
        wgpuQueueSetLabel(self, label);
    }
    pub inline fn submit(self: *Queue, commands: []const *const CommandBuffer) void {
        wgpuQueueSubmit(self, commands.len, commands.ptr);
    }
    pub inline fn writeBuffer(self: *Queue, buffer: *Buffer, buffer_offset: u64, data: *const anyopaque, size: usize) void {
        wgpuQueueWriteBuffer(self, buffer, buffer_offset, data, size);
    }
    pub inline fn writeTexture(self: *Queue, destination: *const ImageCopyTexture, data: *const anyopaque, data_size: usize, data_layout: *const TextureDataLayout, write_size: *const Extent3D) void {
        wgpuQueueWriteTexture(self, destination, data, data_size, data_layout, write_size);
    }
    pub inline fn reference(self: *Queue) void {
        wgpuQueueReference(self);
    }
    pub inline fn release(self: *Queue) void {
        wgpuQueueRelease(self);
    }

    // wgpu-native
    pub inline fn submitForIndex(self: *Queue, commands: []const *const CommandBuffer) SubmissionIndex {
        return wgpuQueueSubmitForIndex(self, commands.len, commands.ptr);
    }
};
