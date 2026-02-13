package extra

//A Logger that maps from raylib's TraceLog to odin's "core:log"

import "core:strings"
import "core:log"
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
