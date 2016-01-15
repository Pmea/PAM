function [m_chroma]= f_CQTtoChroma(spectrum, note_min )

   [acti_note, frames]= size(spectrum);
   m_chroma= zeros(frames, 12);

   for k= 1:frames
        for l=1:acti_note
            pos= mod(l+ note_min -1 , 12)+1;
            m_chroma(k, pos)= chroma(k, pos) + spectrum(l, k);
        end
    end

end
