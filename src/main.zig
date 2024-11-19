const std = @import("std");
const httpz = @import("httpz");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var server = try httpz.Server().init(allocator, .{ .port = 5882 });

    var router = server.router();
    router.get("/health-check", healthCheck);
    router.get("/:name", greet);

    try server.listen();
}

fn healthCheck(_: *httpz.Request, _: *httpz.Response) !void {}

fn greet(req: *httpz.Request, res: *httpz.Response) !void {
    const name = req.param("name") orelse "world";
    try std.fmt.format(res.writer(), "Hello, {s}!\n", .{name});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
