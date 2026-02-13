package extra

import "core:c"
import "core:strings"
import "core:fmt"
import "core:log"
import rl "vendor:raylib"

CreateRaylibLogger :: proc() -> log.Logger {
    rl.SetTraceLogLevel(.ALL)
    return {data = nil, lowest_level = .Debug, options = {}, procedure = raylib_logger_proc}
}

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
