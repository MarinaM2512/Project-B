classdef RespondToEvent < handle
   methods
      function obj = RespondToEvent(event_flag_obj)
         addlistener(event_flag_obj,'EventTrue',@RespondToEvent.handleEvnt);
      end
   end
   methods (Static)
      function handleEvnt(src,~)
          global movements ble_char
         disp('leg movement was detected')
         disp(['writing ble message for movement number ', num2str(src.mov_num)])
         write(ble_char,[movements{src.mov_num}.len,...
                movements{src.mov_num}.torque,...
                movements{src.mov_num}.time,...
                movements{src.mov_num}.active,...
                movements{src.mov_num}.dir]);
      end
   end
end