-- I can't always assume each platform is going to know what to do.
local dateTimeFile,errorStr = io.open("datetime.bin","w+")
if not dateTimeFile then
	error(errorStr)
end
dateTimeFile:write(string.format(os.date("%Y%m%d %H:%S")))
dateTimeFile:flush()
dateTimeFile:close()