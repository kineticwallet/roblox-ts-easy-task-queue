--!nocheck
--!optimize 2

local TaskQueue = {}
TaskQueue.__index = TaskQueue

function TaskQueue.new(onFlush)
	local self = setmetatable({}, TaskQueue)

	self._queue = {}
	self._flushing = false
	self._scheduled = nil
	self._onFlush = onFlush

	return self
end

function TaskQueue:Add(object)
	table.insert(self._queue, object)

	if self._scheduled == nil then
		self._scheduled = task.defer(function()
			self._flushing = true
			self._onFlush(self._queue)
			table.clear(self._queue)
			self._flushing = false
			self._scheduled = nil
		end)
	end
end

function TaskQueue:Clear()
	if self._flushing then
		return
	end

	if self._scheduled ~= nil then
		task.cancel(self._scheduled)
		self._scheduled = nil
	end

	table.clear(self._queue)
end

function TaskQueue:Destroy()
	self:Clear()
end

return TaskQueue
