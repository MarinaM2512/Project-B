classdef BufferEvent < handle
   properties
      State = false
      Msg = MsgEvent
      currentData ={}
      analyzedData ={}
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