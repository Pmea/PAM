function [m_chroma]= f_CQTtoChroma(m_spectrum, note_min )

   [acti_note, frames]= size(m_spectrum);
   m_chroma= zeros(frames, 12);

   for k= 1:frames
        for l=1:acti_note
            pos= mod(l+ note_min -1 , 12)+1;
            m_chroma(k, pos)= m_chroma(k, pos) + m_spectrum(l, k);
        end
   end
   m_chroma= m_chroma';
end
