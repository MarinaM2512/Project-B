classdef BufferEvent < handle
   properties
      State = false
      Msg = MsgEvent
      currentData ={}
      analyzedData = 0
      isAnaliseDone = 1 % value 0 means analisys not done, value 1
      % means anlisys done and new measuremens can be passed to the
      % function
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