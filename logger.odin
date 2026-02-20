package extra

//A Logger that maps from raylib's TraceLog to odin's "core:log"

import "core:log"
import "core:strings"
import rl "vendor:raylib"

//Creates a logger that uses raylib's TraceLog function, you can use "core:log" normally and it will output there
CreateRaylibLogger :: proc() -> log.Logger {
	rl.SetTraceLogLevel(.ALL)
	return {data = nil, lowest_level = .Debug, options = {}, procedure = raylib_logger_proc}
}

//Internal proc that uses TraceLog to write logs
@(private)
raylib_logger_proc :: proc(
	logger_data: rawptr,
	level: log.Level,
	text: string,
	options: log.Options,
	location := #caller_location,
) {
	@(static, rodata)
	odinLevelToRayLibLevel := #sparse[log.Level]rl.TraceLogLevel {
		.Debug   = .DEBUG,
		.Info    = .INFO,
		.Warning = .WARNING,
		.Error   = .ERROR,
		.Fatal   = .FATAL,
	}
	rl.TraceLog(odinLevelToRayLibLevel[level], "%.*s", i32(len(text)), raw_data(text))
}
