classdef RespondToBufferEvent < handle
   methods
      function obj = RespondToBufferEvent(buffer_event_obj)
         addlistener(buffer_event_obj,'BufferEventTrue',@RespondToBufferEvent.handleEvnt);
      end
   end
   methods (Static)
      function handleEvnt(src,~)
         disp('buffer is full or new data-point arrived - do analysis')
         
         %%%%%%%%%%%% do analysis: %%%%%%%%%%%%%%%%
         is_mov_detect = main_analysis(src);
         %%%%%%%%%%%%%%% end  of analysis %%%%%%%%%%%%
         
         % check if a message need to be sent
         src.Msg.OnEventChange(is_mov_detect);
      end
   end
end