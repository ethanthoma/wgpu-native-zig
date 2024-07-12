const ChainedStruct = @import("chained_struct.zig").ChainedStruct;

const _adapter = @import("adapter.zig");
const Adapter = _adapter.Adapter;
const RequestAdapterOptions = _adapter.RequestAdapterOptions;
const RequestAdapterCallback = _adapter.RequestAdapterCallback;
const RequestAdapterStatus = _adapter.RequestAdapterStatus;
const RequestAdapterResponse = _adapter.RequestAdapterResponse;

const _surface = @import("surface.zig");
const Surface = _surface.Surface;
const SurfaceDescriptor = _surface.SurfaceDescriptor;

pub const InstanceDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
};

pub const InstanceProcs = struct {
    pub const CreateInstance = *const fn(?*const InstanceDescriptor) callconv(.C) ?*Instance;
    pub const ProcessEvents = *const fn(*Instance) callconv(.C) void;
    pub const RequestAdapter = *const fn(*Instance, ?*const RequestAdapterOptions, RequestAdapterCallback, ?*anyopaque) callconv(.C) void;
    pub const InstanceReference = *const fn(*Instance) callconv(.C) void;
    pub const InstanceRelease = *const fn(*Instance) callconv(.C) void;
};


extern fn wgpuCreateInstance(descriptor: ?*const InstanceDescriptor) ?*Instance;
extern fn wgpuInstanceCreateSurface(instance: *Instance, descriptor: *const SurfaceDescriptor) ?*Surface;
extern fn wgpuInstanceProcessEvents(instance: *Instance) void;
extern fn wgpuInstanceRequestAdapter(instance: *Instance, options: ?*const RequestAdapterOptions, callback: RequestAdapterCallback, userdata: ?*anyopaque) void;
extern fn wgpuInstanceReference(instance: *Instance) void;
extern fn wgpuInstanceRelease(instance: *Instance) void;

pub const Instance = opaque {
    pub inline fn create(descriptor: ?*const InstanceDescriptor) ?*Instance {
        return wgpuCreateInstance(descriptor);
    }

    pub inline fn createSurface(self: *Instance, descriptor: *const SurfaceDescriptor) ?*Surface {
        return wgpuInstanceCreateSurface(self, descriptor);
    }

    pub inline fn processEvents(self: *Instance) void {
        wgpuInstanceProcessEvents(self);
    }

    fn defaultAdapterCallback(status: RequestAdapterStatus, adapter: ?*Adapter, message: ?[*:0]const u8, userdata: ?*anyopaque) callconv(.C) void {
        const ud_response: *RequestAdapterResponse = @ptrCast(@alignCast(userdata));
        ud_response.* = RequestAdapterResponse {
            .status = status,
            .message = message,
            .adapter = adapter,
        };
    }

    pub fn requestAdapter(self: *Instance, options: ?*const RequestAdapterOptions) RequestAdapterResponse {
        var response: RequestAdapterResponse = undefined;
        wgpuInstanceRequestAdapter(self, options, defaultAdapterCallback, @ptrCast(&response));
        return response;
    }

    pub inline fn requestAdapterWithCallback(self: *Instance, options: ?*const RequestAdapterOptions, callback: RequestAdapterCallback, userdata: ?*anyopaque) void {
        wgpuInstanceRequestAdapter(self, options, callback, userdata);
    }

    // Dunno what this does, but it appears in webgpu.h so I guess it's important?
    pub inline fn reference(self: *Instance) void {
        // TODO: Find out WTF wgpuInstanceReference does.
        wgpuInstanceReference(self);
    }

    pub inline fn release(self: *Instance) void {
        wgpuInstanceRelease(self);
    }
};

test "can create instance (and release it afterwards)" {
    const testing = @import("std").testing;

    const instance = Instance.create(null);
    try testing.expect(instance != null);
    instance.?.release();
}