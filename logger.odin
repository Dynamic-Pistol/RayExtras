package extra

import "core:c"
import "core:strings"
import "core:fmt"
import "core:log"
import rl "vendor:raylib"

RayLib_Logger :: struct {
}

create_raylib_logger :: proc(
	lowest := log.Level.Debug,
	allocator := context.allocator,
) -> log.Logger {
    data := new(RayLib_Logger, allocator)
    data^ = RayLib_Logger{
    }
	return {data = data, lowest_level = .Debug, options = {}, procedure = raylib_logger_proc}
}

destroy_raylib_logger :: proc(logger: log.Logger) {
    free(logger.data)
}

raylib_logger_proc :: proc(
	logger_data: rawptr,
	level: log.Level,
	text: string,
	options: log.Options,
	location := #caller_location,
) {
	options := options
    cText := strings.unsafe_string_to_cstring(text)
    switch level{
        case .Debug:
	        rl.TraceLog(.DEBUG, cText)
        case .Info:
	        rl.TraceLog(.INFO, cText)
        case .Warning:
	        rl.TraceLog(.WARNING, cText)
        case .Fatal:
	        rl.TraceLog(.FATAL, cText)
        case .Error:
	        rl.TraceLog(.ERROR, cText)
	}
}