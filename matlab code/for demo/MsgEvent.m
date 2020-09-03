classdef MsgEvent < handle
   properties
      State = false
      mov_num = 0
   end
   events
      EventTrue
   end
   methods
      function OnEventChange(obj,newState)
         if newState
            obj.State = false; %reset to pervios condition
            notify(obj,'EventTrue');
         end
      end
   end
end