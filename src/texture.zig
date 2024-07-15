const ChainedStruct = @import("chained_struct.zig").ChainedStruct;

const _misc = @import("misc.zig");
const WGPUFlags = _misc.WGPUFlags;
const WGPUBool = _misc.WGPUBool;

pub const TextureFormat = enum(u32) {
    @"undefined"            = 0x00000000,
    r8_unorm                = 0x00000001,
    r8_snorm                = 0x00000002,
    r8_uint                 = 0x00000003,
    r8_sint                 = 0x00000004,
    r16_uint                = 0x00000005,
    r16_sint                = 0x00000006,
    r16_float               = 0x00000007,
    rg8_unorm               = 0x00000008,
    rg8_snorm               = 0x00000009,
    rg8_uint                = 0x0000000A,
    rg8_sint                = 0x0000000B,
    r32_float               = 0x0000000C,
    r32_uint                = 0x0000000D,
    r32_sint                = 0x0000000E,
    rg16_uint               = 0x0000000F,
    rg16_sint               = 0x00000010,
    rg16_float              = 0x00000011,
    rgba8_unorm             = 0x00000012,
    rgba8_unorm_srgb        = 0x00000013,
    rgba8_snorm             = 0x00000014,
    rgba8_uint              = 0x00000015,
    rgba8_sint              = 0x00000016,
    bgra8_unorm             = 0x00000017,
    bgra8_unorm_srgb        = 0x00000018,
    rgb10a2_uint            = 0x00000019,
    rgb10a2_unorm           = 0x0000001A,
    rg11b10_ufloat          = 0x0000001B,
    rgb9e5_ufloat           = 0x0000001C,
    rg32_float              = 0x0000001D,
    rg32_uint               = 0x0000001E,
    rg32_sint               = 0x0000001F,
    rgba16_uint             = 0x00000020,
    rgba16_sint             = 0x00000021,
    rgba16_float            = 0x00000022,
    rgba32_float            = 0x00000023,
    rgba32_uint             = 0x00000024,
    rgba32_sint             = 0x00000025,
    stencil8                = 0x00000026,
    depth16_unorm           = 0x00000027,
    depth24_plus            = 0x00000028,
    depth24_plus_stencil8   = 0x00000029,
    depth32_float           = 0x0000002A,
    depth32_float_stencil8  = 0x0000002B,
    bc1_rgba_unorm          = 0x0000002C,
    bc1_rgba_unorm_srgb     = 0x0000002D,
    bc2_rgba_unorm          = 0x0000002E,
    bc2_rgba_unorm_srgb     = 0x0000002F,
    bc3_rgba_unorm          = 0x00000030,
    bc3_rgba_unorm_srgb     = 0x00000031,
    bc4_r_unorm             = 0x00000032,
    bc4_r_snorm             = 0x00000033,
    bc5_rg_unorm            = 0x00000034,
    bc5_rg_snorm            = 0x00000035,
    bc6_hrgb_ufloat         = 0x00000036,
    bc6_hrgb_float          = 0x00000037,
    bc7_rgba_unorm          = 0x00000038,
    bc7_rgba_unorm_srgb     = 0x00000039,
    etc2_rgb8_unorm         = 0x0000003A,
    etc2_rgb8_unorm_srgb    = 0x0000003B,
    etc2_rgb8a1_unorm       = 0x0000003C,
    etc2_rgb8a1_unorm_srgb  = 0x0000003D,
    etc2_rgba8_unorm        = 0x0000003E,
    etc2_rgba8_unorm_srgb   = 0x0000003F,
    eacr11_unorm            = 0x00000040,
    eacr11_snorm            = 0x00000041,
    eacrg11_unorm           = 0x00000042,
    eacrg11_snorm           = 0x00000043,
    astc4x4_unorm           = 0x00000044,
    astc4x4_unorm_srgb      = 0x00000045,
    astc5x4_unorm           = 0x00000046,
    astc5x4_unorm_srgb      = 0x00000047,
    astc5x5_unorm           = 0x00000048,
    astc5x5_unorm_srgb      = 0x00000049,
    astc6x5_unorm           = 0x0000004A,
    astc6x5_unorm_srgb      = 0x0000004B,
    astc6x6_unorm           = 0x0000004C,
    astc6x6_unorm_srgb      = 0x0000004D,
    astc8x5_unorm           = 0x0000004E,
    astc8x5_unorm_srgb      = 0x0000004F,
    astc8x6_unorm           = 0x00000050,
    astc8x6_unorm_srgb      = 0x00000051,
    astc8x8_unorm           = 0x00000052,
    astc8x8_unorm_srgb      = 0x00000053,
    astc10x5_unorm          = 0x00000054,
    astc10x5_unorm_srgb     = 0x00000055,
    astc10x6_unorm          = 0x00000056,
    astc10x6_unorm_srgb     = 0x00000057,
    astc10x8_unorm          = 0x00000058,
    astc10x8_unorm_srgb     = 0x00000059,
    astc10x10_unorm         = 0x0000005A,
    astc10x10_unorm_srgb    = 0x0000005B,
    astc12x10_unorm         = 0x0000005C,
    astc12x10_unorm_srgb    = 0x0000005D,
    astc12x12_unorm         = 0x0000005E,
    astc12x12_unorm_srgb    = 0x0000005F,
};

pub const TextureUsageFlags = WGPUFlags;
pub const TextureUsage = struct {
    pub const none              = @as(TextureUsageFlags, 0x00000000);
    pub const copy_src          = @as(TextureUsageFlags, 0x00000001);
    pub const copy_dst          = @as(TextureUsageFlags, 0x00000002);
    pub const texture_binding   = @as(TextureUsageFlags, 0x00000004);
    pub const storage_binding   = @as(TextureUsageFlags, 0x00000008);
    pub const render_attachment = @as(TextureUsageFlags, 0x00000010);
};

pub const TextureView = opaque {
    // TODO: fill in methods
};

// TODO: Should this maybe go in sampler.zig instead?
pub const SampleType = enum(u32) {
    @"undefined"       = 0x00000000,
    float              = 0x00000001,
    unfilterable_float = 0x00000002,
    depth              = 0x00000003,
    s_int              = 0x00000004,
    u_int              = 0x00000005,
};

pub const ViewDimension = enum(u32) {
    @"undefined" = 0x00000000,
    @"1d"        = 0x00000001,
    @"2d"        = 0x00000002,
    @"2d_array"  = 0x00000003,
    cube         = 0x00000004,
    cube_array   = 0x00000005,
    @"3d"        = 0x00000006,
};

pub const TextureBindingLayout = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    sample_type: SampleType,
    view_dimension: ViewDimension,
    multisampled: WGPUBool,
};

pub const StorageTextureAccess = enum(u32) {
    @"undefined" = 0x00000000,
    write_only   = 0x00000001,
    read_only    = 0x00000002,
    read_write   = 0x00000003,
};

pub const StorageTextureBindingLayout = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    access: StorageTextureAccess,
    format: TextureFormat,
    view_dimension: ViewDimension,
};

pub const TextureDimension = enum(u32) {
    @"1d" = 0x00000000,
    @"2d" = 0x00000001,
    @"3d" = 0x00000002,
};

pub const Extent3D = extern struct {
    width: u32,
    height: u32,
    depth_or_array_layers: u32,
};

pub const TextureDescriptor = extern struct {
    next_in_chain: ?*const ChainedStruct = null,
    label: ?[*:0]const u8 = null,
    usage: TextureUsageFlags,
    dimension: TextureDimension,
    size: Extent3D,
    format: TextureFormat,
    mip_level_count: u32,
    sample_count: u32,
    view_format_count: usize,
    view_formats: [*]const TextureFormat,
};

pub const Texture = opaque {
    // TODO: fill in methods
};