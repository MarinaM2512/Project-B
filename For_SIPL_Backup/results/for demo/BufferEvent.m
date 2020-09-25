classdef BufferEvent < handle
   properties
      State = false
      Msg = MsgEvent
      currentData ={}
      analyzedData = 0 % counter to ensure that movements will not be 
      % recognised in the few next samples after movement recognition
      isAnaliseDone = 1 % value 0 means analisys not finished, value 1
      % means anlisys finished and new measuremens can be passed to the
      %analisys function
   end
   events
      BufferEventTrue
   end
   methods
      function OnEventChange(obj,newState)
         if newState
            obj.State = false; %reset to pervios condition
            notify(obj,'BufferEventTrue');
         end
      end
   end
end